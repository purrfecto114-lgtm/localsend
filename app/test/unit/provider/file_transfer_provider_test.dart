import 'package:localsend_app/provider/file_transfer_provider.dart';
import 'package:localsend_isolates/model/file_status.dart';
import 'package:refena_flutter/refena_flutter.dart';
import 'package:test/test.dart';

/// Tests for [FileTransferNotifier].
///
/// Upstream semantics (restored in fork.4 after the fork.1 50ms merge window
/// was reported as visibly coarsening the progress animation): every update
/// notifies listeners immediately, so the progress page reflects each event
/// the moment it arrives.
void main() {
  late _ChangeCounter observer;
  late RefenaContainer container;
  late FileTransferNotifier notifier;

  setUp(() {
    observer = _ChangeCounter();
    container = RefenaContainer(observers: [observer]);
    notifier = container.notifier(fileTransferProvider);
  });

  tearDown(() {
    container.disposeContainer();
  });

  test('every progress update notifies immediately', () {
    for (var i = 1; i <= 100; i++) {
      notifier.setProgress(sessionId: 's', fileId: 'f', progress: i / 100);
    }

    // No merging: each of the 100 events rebuilt the listeners.
    expect(observer.count, 100);
    expect(notifier.getProgress(sessionId: 's', fileId: 'f'), 1.0);
  });

  test('every status update notifies immediately', () {
    notifier.setStatus(sessionId: 's', fileId: 'a', status: FileStatus.queue);
    expect(observer.count, 1);
    notifier.setStatus(sessionId: 's', fileId: 'a', status: FileStatus.sending);
    expect(observer.count, 2);
    notifier.setStatus(sessionId: 's', fileId: 'a', status: FileStatus.finished);
    expect(observer.count, 3);
    expect(notifier.getStatus(sessionId: 's', fileId: 'a'), FileStatus.finished);
  });

  test('setStatuses notifies only once for the whole batch', () {
    notifier.setStatuses(
      sessionId: 's',
      statuses: {
        'a': FileStatus.queue,
        'b': FileStatus.queue,
      },
    );
    expect(observer.count, 1);
    expect(notifier.getStatuses('s').length, 2);
  });

  test('removeSession notifies immediately', () {
    notifier.setStatus(sessionId: 's', fileId: 'a', status: FileStatus.queue);
    expect(observer.count, 1);

    notifier.removeSession('s');
    expect(observer.count, 2);
    expect(notifier.getStatuses('s'), isEmpty);
  });

  test('removeAllSessions notifies immediately', () {
    notifier.setStatus(sessionId: 's', fileId: 'a', status: FileStatus.queue);
    notifier.removeAllSessions();
    expect(observer.count, 2);
    expect(notifier.getStatuses('s'), isEmpty);
  });

  test('sessions are tracked independently', () {
    notifier.setStatus(sessionId: 's1', fileId: 'a', status: FileStatus.queue);
    notifier.setStatus(sessionId: 's2', fileId: 'a', status: FileStatus.queue);
    expect(observer.count, 2);

    notifier.setStatus(sessionId: 's2', fileId: 'a', status: FileStatus.finished);
    expect(observer.count, 3);
    expect(notifier.getStatus(sessionId: 's1', fileId: 'a'), FileStatus.queue);
    expect(notifier.getStatus(sessionId: 's2', fileId: 'a'), FileStatus.finished);
  });

  test('progress updates keep the existing status of a file', () {
    notifier.setStatus(sessionId: 's', fileId: 'a', status: FileStatus.sending);
    notifier.setProgress(sessionId: 's', fileId: 'a', progress: 0.5);
    expect(notifier.getStatus(sessionId: 's', fileId: 'a'), FileStatus.sending);
    expect(notifier.getProgress(sessionId: 's', fileId: 'a'), 0.5);
  });
}

/// Counts the change events of the file transfer notifier,
/// i.e. the number of notifyListeners calls.
class _ChangeCounter extends RefenaObserver {
  int count = 0;

  @override
  void handleEvent(RefenaEvent event) {
    if (event is ChangeEvent && event.notifier is FileTransferNotifier) {
      count++;
    }
  }
}
