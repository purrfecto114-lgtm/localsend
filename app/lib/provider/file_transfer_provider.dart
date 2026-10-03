import 'dart:async';

import 'package:localsend_isolates/model/file_status.dart';
import 'package:refena_flutter/refena_flutter.dart';

/// A provider holding the live per-file transfer state (status and progress).
/// It is implemented as [ChangeNotifier] for performance reasons:
/// a status or progress update does not need to copy the whole session state.
final fileTransferProvider = ChangeNotifierProvider((ref) => FileTransferNotifier());

class FileTransfer {
  FileStatus status;
  double progress; // 0..1

  FileTransfer(this.status) : progress = 0;

  @override
  String toString() => '($status, $progress)';
}

/// The live per-file transfer state of all sessions.
///
/// Routine updates (progress, queue/sending status and per-file
/// finished/failed/skipped statuses while other files are still in flight)
/// are merged into a time window before [notifyListeners] is called, see
/// [_notifyWindow]. Updates that complete a session and session removals
/// notify immediately, see [_notifyNow].
class FileTransferNotifier extends ChangeNotifier {
  /// Minimum time between two [notifyListeners] calls for routine updates.
  ///
  /// The Rust side already throttles per-file progress callbacks to 20ms, but
  /// with an upload concurrency of 2 and many small files the Dart side still
  /// receives roughly 100 events per second (every tiny file emits at least
  /// Started, one final Progress and Finished). Every notification rebuilds
  /// ProgressPage, which folds over ALL files of the session twice (current
  /// bytes and finished count), so 15k files turn each individual event into
  /// an O(n) full-page rebuild. Merging routine updates into a ~50ms window
  /// (about 3 frames, still visually smooth) caps the rebuild rate at ~20/s
  /// regardless of the file count.
  static const _notifyWindow = Duration(milliseconds: 50);

  final _sessionMap = <String, Map<String, FileTransfer>>{}; // session id -> (file id -> live transfer state)

  /// Number of files per session that are not yet in a terminal status.
  /// Keeps the session-completion check O(1): the update that brings this
  /// down to zero is the "transfer finished" event and must notify
  /// immediately.
  final _unfinishedCount = <String, int>{};

  DateTime _lastNotify = DateTime.fromMillisecondsSinceEpoch(0);
  Timer? _trailingNotify;

  void setStatus({required String sessionId, required String fileId, required FileStatus status}) {
    _updateStatus(sessionId, fileId, status);
    _afterStatusUpdate(sessionId);
  }

  /// Sets the status of multiple files at once, notifying listeners only once.
  void setStatuses({required String sessionId, required Map<String, FileStatus> statuses}) {
    for (final entry in statuses.entries) {
      _updateStatus(sessionId, entry.key, entry.value);
    }
    _afterStatusUpdate(sessionId);
  }

  void setProgress({required String sessionId, required String fileId, required double progress}) {
    final files = _sessionMap.putIfAbsent(sessionId, () => {});
    final existing = files[fileId];
    if (existing == null) {
      files[fileId] = FileTransfer(FileStatus.queue)..progress = progress;
      _unfinishedCount[sessionId] = (_unfinishedCount[sessionId] ?? 0) + 1;
    } else {
      existing.progress = progress;
    }
    _notifyThrottled();
  }

  FileStatus getStatus({required String sessionId, required String fileId}) {
    return _sessionMap[sessionId]?[fileId]?.status ?? FileStatus.queue;
  }

  Iterable<FileStatus> getStatuses(String sessionId) {
    return _sessionMap[sessionId]?.values.map((file) => file.status) ?? const [];
  }

  double getProgress({required String sessionId, required String fileId}) {
    return _sessionMap[sessionId]?[fileId]?.progress ?? 0.0;
  }

  void removeSession(String sessionId) {
    _sessionMap.remove(sessionId);
    _unfinishedCount.remove(sessionId);
    _notifyNow();
  }

  void removeAllSessions() {
    _sessionMap.clear();
    _unfinishedCount.clear();
    _notifyNow();
  }

  /// Only for debug purposes
  Map<String, Map<String, FileTransfer>> getData() {
    return _sessionMap;
  }

  @override
  void dispose() {
    _trailingNotify?.cancel();
    _trailingNotify = null;
    super.dispose();
  }

  /// Updates the status of one file, keeping [_unfinishedCount] in sync.
  void _updateStatus(String sessionId, String fileId, FileStatus status) {
    final files = _sessionMap.putIfAbsent(sessionId, () => {});
    final existing = files[fileId];
    if (existing == null) {
      files[fileId] = FileTransfer(status);
      if (!_isTerminal(status)) {
        _unfinishedCount[sessionId] = (_unfinishedCount[sessionId] ?? 0) + 1;
      }
    } else {
      final wasUnfinished = !_isTerminal(existing.status);
      final isUnfinished = !_isTerminal(status);
      existing.status = status;
      if (wasUnfinished != isUnfinished) {
        _unfinishedCount[sessionId] = (_unfinishedCount[sessionId] ?? 0) + (isUnfinished ? 1 : -1);
      }
    }
  }

  /// Notifies after a status update: immediately when the update completes
  /// the session (every file reached a terminal status - this covers the
  /// last finished file as well as marking a whole session failed, e.g. on
  /// cancel), otherwise merged into the [_notifyWindow].
  void _afterStatusUpdate(String sessionId) {
    if ((_unfinishedCount[sessionId] ?? 0) == 0) {
      _notifyNow();
    } else {
      _notifyThrottled();
    }
  }

  /// A status a file does not leave again during the transfer.
  static bool _isTerminal(FileStatus status) {
    return status == FileStatus.finished || status == FileStatus.failed || status == FileStatus.skipped;
  }

  /// Notifies listeners immediately, replacing a scheduled merged
  /// notification. Used for terminal events (session complete, session
  /// removed) so that the UI always reflects the final state without delay.
  void _notifyNow() {
    _trailingNotify?.cancel();
    _trailingNotify = null;
    _lastNotify = DateTime.now();
    notifyListeners();
  }

  /// Merges this notification with all updates arriving within the window:
  /// the state is already updated, but [notifyListeners] runs at most once
  /// per [_notifyWindow]. If the window has already elapsed since the last
  /// notification, listeners are notified right away; otherwise a trailing
  /// timer publishes the accumulated state when the window expires. The
  /// trailing timer guarantees that the final state is always published,
  /// even if no further event arrives.
  void _notifyThrottled() {
    if (_trailingNotify != null) {
      // A notification is already scheduled and will include this update.
      return;
    }
    final sinceLastNotify = DateTime.now().difference(_lastNotify);
    if (sinceLastNotify >= _notifyWindow) {
      _notifyNow();
      return;
    }
    _trailingNotify = Timer(_notifyWindow - sinceLastNotify, _notifyNow);
  }
}
