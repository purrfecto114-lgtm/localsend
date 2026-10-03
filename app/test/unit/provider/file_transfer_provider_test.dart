import 'package:localsend_app/provider/file_transfer_provider.dart';
import 'package:localsend_isolates/model/file_status.dart';
import 'package:refena_flutter/refena_flutter.dart';
import 'package:test/test.dart';

/// Tests for the notify throttling of [FileTransferNotifier].
///
/// Routine per-file updates (progress, queue/sending status, per-file
/// finished/failed while other files are still in flight) are merged into a
/// 50ms window: with 15k files, every single event would otherwise rebuild
/// ProgressPage, which folds over all files of the session twice. Events that
/// complete a session (the last file reaching a terminal status, or marking a
/// whole session failed) and session removals must notify immediately, and
/// the trailing flush must always publish the final state.
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

  test('a burst of progress updates merges into one immediate and one trailing notify', () async {
    for (var i = 1; i <= 100; i++) {
      notifier.setProgress(sessionId: 's', fileId: 'f', progress: i / 100);
    }

    // The first update after a quiet period notifies immediately;
    // the other 99 are merged into the pending trailing notify.
    expect(observer.count, 1);
    // The state is already updated even before the notification fires.
    expect(notifier.getProgress(sessionId: 's', fileId: 'f'), 1.0);

    await Future<void>.delayed(const Duration(milliseconds: 120));

    expect(observer.count, 2);
    expect(notifier.getProgress(sessionId: 's', fileId: 'f'), 1.0);
  });

  test('a burst after the window elapsed notifies immediately again', () async {
    for (var i = 1; i <= 50; i++) {
      notifier.setProgress(sessionId: 's', fileId: 'f', progress: i / 100);
    }
    expect(observer.count, 1); // immediate, the rest merged
    await Future<void>.delayed(const Duration(milliseconds: 120));
    expect(observer.count, 2); // the trailing flush published the final state

    // More than 50ms since the last notify: no merging window anymore.
    notifier.setProgress(sessionId: 's', fileId: 'f', progress: 0.2);
    expect(observer.count, 3);
    expect(notifier.getProgress(sessionId: 's', fileId: 'f'), 0.2);
  });

  test('per-file finished updates merge while other files are still unfinished', () async {
    notifier.setStatuses(
      sessionId: 's',
      statuses: {
        'a': FileStatus.queue,
        'b': FileStatus.queue,
      },
    );
    expect(observer.count, 1); // quiet period -> immediate

    notifier.setStatus(sessionId: 's', fileId: 'a', status: FileStatus.sending);
    notifier.setStatus(sessionId: 's', fileId: 'a', status: FileStatus.finished);
    notifier.setStatus(sessionId: 's', fileId: 'b', status: FileStatus.sending);

    // One file is still unfinished, so all of the above merged.
    expect(observer.count, 1);
    // The state is already updated even before the notification fires.
    expect(notifier.getStatus(sessionId: 's', fileId: 'a'), FileStatus.finished);

    await Future<void>.delayed(const Duration(milliseconds: 120));
    expect(observer.count, 2);
  });

  test('the update completing a session notifies immediately', () async {
    notifier.setStatuses(
      sessionId: 's',
      statuses: {
        'a': FileStatus.queue,
        'b': FileStatus.queue,
      },
    );
    notifier.setStatus(sessionId: 's', fileId: 'a', status: FileStatus.finished);
    expect(observer.count, 1); // merged so far

    notifier.setStatus(sessionId: 's', fileId: 'b', status: FileStatus.finished);

    // b was the last unfinished file: this is the "transfer finished" event.
    expect(observer.count, 2);
    expect(notifier.getStatus(sessionId: 's', fileId: 'b'), FileStatus.finished);

    // The pending merged notify was consumed by the immediate one.
    await Future<void>.delayed(const Duration(milliseconds: 120));
    expect(observer.count, 2);
  });

  test('a single-file session notifies immediately when the file finishes', () async {
    notifier.setStatus(sessionId: 's', fileId: 'only', status: FileStatus.sending);
    expect(observer.count, 1);

    notifier.setProgress(sessionId: 's', fileId: 'only', progress: 0.5);
    expect(observer.count, 1); // merged

    notifier.setStatus(sessionId: 's', fileId: 'only', status: FileStatus.failed);
    expect(observer.count, 2); // completes the session -> immediate
    expect(notifier.getStatus(sessionId: 's', fileId: 'only'), FileStatus.failed);
    expect(notifier.getProgress(sessionId: 's', fileId: 'only'), 0.5);
  });

  test('marking a whole session failed (cancel/failure) notifies immediately', () async {
    notifier.setStatuses(
      sessionId: 's',
      statuses: {
        'a': FileStatus.queue,
        'b': FileStatus.sending,
      },
    );
    expect(observer.count, 1);

    notifier.setStatuses(
      sessionId: 's',
      statuses: {
        'a': FileStatus.failed,
        'b': FileStatus.failed,
      },
    );

    expect(observer.count, 2);
    expect(notifier.getStatuses('s').every((status) => status == FileStatus.failed), isTrue);
  });

  test('removeSession notifies immediately and cancels pending notifies', () async {
    notifier.setStatus(sessionId: 's', fileId: 'a', status: FileStatus.queue);
    expect(observer.count, 1);

    notifier.setProgress(sessionId: 's', fileId: 'a', progress: 0.3); // merged, scheduled
    notifier.removeSession('s');

    expect(observer.count, 2);
    expect(notifier.getStatuses('s'), isEmpty);

    await Future<void>.delayed(const Duration(milliseconds: 120));
    expect(observer.count, 2); // no trailing notify afterwards
  });

  test('sessions are tracked independently', () async {
    notifier.setStatus(sessionId: 's1', fileId: 'a', status: FileStatus.queue);
    notifier.setStatus(sessionId: 's2', fileId: 'a', status: FileStatus.queue);
    expect(observer.count, 1); // first update immediate, the second merged

    // Completing s2 must not be affected by s1 still being unfinished.
    notifier.setStatus(sessionId: 's2', fileId: 'a', status: FileStatus.finished);
    expect(observer.count, 2);
    expect(notifier.getStatus(sessionId: 's1', fileId: 'a'), FileStatus.queue);
    expect(notifier.getStatus(sessionId: 's2', fileId: 'a'), FileStatus.finished);

    // Completing s1 notifies immediately as well.
    notifier.setStatus(sessionId: 's1', fileId: 'a', status: FileStatus.finished);
    expect(observer.count, 3);
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
