import 'dart:io';

import 'package:logging/logging.dart';

final _logger = Logger('SourceFileDeletion');

/// Matches strings that carry a URI scheme followed by `://`, e.g.
/// `content://...` or `https://...`.
///
/// Plain filesystem paths never match: POSIX paths start with `/`, Windows
/// drive letters (`C:\...` or `C:/...`) and UNC shares (`\\server\...`) do
/// not contain `://` behind a scheme-like prefix.
final _uriSchemePattern = RegExp(r'^[a-zA-Z][a-zA-Z0-9+.\-]*://');

/// Resolves the source path of a sent file to a path on the local filesystem
/// that can be deleted with [File].
///
/// Returns `null` when the source cannot be deleted as a local file:
///  - there is no path at all (the file was sent from memory,
///    e.g. a text message or clipboard content),
///  - the source is a platform URI such as Android's `content://`: the app
///    has no platform channel to delete the document behind it, so those
///    sources are skipped,
///  - a `file://` URI that cannot be converted to a filesystem path.
String? resolveDeletableSourcePath(String? path) {
  if (path == null || path.isEmpty) {
    return null;
  }

  if (path.startsWith('file://')) {
    try {
      return Uri.parse(path).toFilePath();
    } catch (e) {
      _logger.warning('Could not convert file URI to a path: $path', e);
      return null;
    }
  }

  if (_uriSchemePattern.hasMatch(path)) {
    // content:// (Android SAF), ph:// (iOS) and friends: deleting the
    // document behind such a URI needs a platform channel that this app
    // does not have, so the source is kept.
    _logger.info('Skipping source behind a platform URI: $path');
    return null;
  }

  return path;
}

/// Deletes one source file of a successfully finished send session.
///
/// Never throws: the transfer already succeeded, so a failed cleanup is
/// only logged and never surfaces as an error of the session.
Future<void> deleteSourceFileQuietly(String path) async {
  try {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
      _logger.info('Deleted source file after successful send: $path');
    } else {
      _logger.info('Source file is already gone: $path');
    }
  } catch (e) {
    _logger.warning('Could not delete source file: $path', e);
  }
}
