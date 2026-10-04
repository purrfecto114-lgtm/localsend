import 'package:localsend_app/pages/home_page.dart';
import 'package:localsend_app/pages/home_page_controller.dart';
import 'package:localsend_app/provider/network/send_provider.dart';
import 'package:localsend_app/provider/selection/selected_sending_files_provider.dart';
import 'package:localsend_app/util/native/cross_file_converters.dart';
import 'package:refena_flutter/addons.dart';
import 'package:refena_flutter/refena_flutter.dart';
import 'package:share_handler/share_handler.dart';

/// Handles an incoming share intent (iOS share sheet, Android share, ...),
/// both the initial payload at app start and the ones arriving later through
/// the shared media stream.
///
/// A new share supersedes the previous result screen: send sessions that are
/// already in a terminal state (finished, declined, ...) are closed first, so
/// their pages pop back to the home page and the send tab shows the selection
/// UI with the newly shared files instead of the stale result (#3197).
/// Sessions that are still in flight (waiting / sending) are never touched;
/// the new files are simply queued in the selection while the transfer keeps
/// running.
class HandleShareIntentAction extends AsyncGlobalAction {
  final SharedMedia payload;

  HandleShareIntentAction({
    required this.payload,
  });

  @override
  Future<void> reduce() async {
    // Close stale send sessions before adding the new files.
    // The cache must not be wiped here: the attachments of this very payload
    // live in it, so deleting them would break the transfer before it starts.
    final closedSessions = ref.notifier(sendProvider).closeTerminalSessions(clearCache: false);
    if (closedSessions > 0) {
      // Pop the result screen of a closed session (ProgressPage / SendPage)
      // back to the home page. This is a no-op when already at the root.
      // The pages themselves also react to their session disappearing.
      ref.global.dispatch(NavigateAction.popUntilRoot());
    }

    final message = payload.content;
    if (message != null && message.trim().isNotEmpty) {
      ref.redux(selectedSendingFilesProvider).dispatch(AddMessageAction(message: message));
    }
    await ref
        .redux(selectedSendingFilesProvider)
        .dispatchAsync(
          AddFilesAction(
            files: payload.attachments?.where((a) => a != null).cast<SharedAttachment>() ?? <SharedAttachment>[],
            converter: CrossFileConverters.convertSharedAttachment,
          ),
        );

    ref.redux(homePageControllerProvider).dispatch(ChangeTabAction(HomeTab.send));
  }
}
