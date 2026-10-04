import 'dart:io';

import 'package:localsend_app/util/source_file_deletion.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

/// Unit tests for the source path resolver and the quiet deletion used by
/// the "delete source files after sending" feature.
void main() {
  group('resolveDeletableSourcePath', () {
    test('null and empty paths are not deletable (files sent from memory)', () {
      expect(resolveDeletableSourcePath(null), isNull);
      expect(resolveDeletableSourcePath(''), isNull);
    });

    test('plain filesystem paths are returned unchanged', () {
      expect(resolveDeletableSourcePath('/tmp/some file.txt'), '/tmp/some file.txt');
      expect(resolveDeletableSourcePath(r'C:\Users\John Doe\file.txt'), r'C:\Users\John Doe\file.txt');
      expect(resolveDeletableSourcePath(r'\\server\share\file.txt'), r'\\server\share\file.txt');
    });

    test('file:// URIs are converted to filesystem paths', () async {
      final dir = await Directory.systemTemp.createTemp('ls_resolver_test');
      addTearDown(() => dir.delete(recursive: true));
      final file = File(p.join(dir.path, 'a file.txt'))..writeAsStringSync('x');

      final uri = p.toUri(file.path).toString();
      expect(uri.startsWith('file://'), isTrue);
      expect(resolveDeletableSourcePath(uri), file.path);
    });

    test('platform URIs are skipped, not converted', () {
      // Android SAF, iOS PhotoKit and remote URIs would need a platform
      // channel this app does not have; the source must be kept.
      expect(resolveDeletableSourcePath('content://media/external/images/media/42'), isNull);
      expect(resolveDeletableSourcePath('content://com.example.provider/document/1'), isNull);
      expect(resolveDeletableSourcePath('ph://F2E5C5A6-7B4D-4C8E-9A1B-3D2E1F0A9B8C/L0/001'), isNull);
      expect(resolveDeletableSourcePath('https://example.com/file.txt'), isNull);
    });
  });

  group('deleteSourceFileQuietly', () {
    test('deletes an existing file', () async {
      final dir = await Directory.systemTemp.createTemp('ls_delete_test');
      addTearDown(() => dir.delete(recursive: true));
      final file = File(p.join(dir.path, 'gone.txt'))..writeAsStringSync('x');

      await deleteSourceFileQuietly(file.path);
      expect(file.existsSync(), isFalse);
    });

    test('tolerates a file that is already gone', () async {
      final dir = await Directory.systemTemp.createTemp('ls_delete_test');
      addTearDown(() => dir.delete(recursive: true));
      final missing = p.join(dir.path, 'missing.txt');

      // Reaching the end without throwing is the assertion.
      await deleteSourceFileQuietly(missing);
    });

    test('a deletion failure is contained and never surfaces', () async {
      final dir = await Directory.systemTemp.createTemp('ls_delete_locked');
      addTearDown(() async {
        if (!Platform.isWindows) {
          // Restore the mode so the tear-down cleanup can remove the directory.
          await Process.run('chmod', ['700', dir.path]);
        }
        if (dir.existsSync()) {
          await dir.delete(recursive: true);
        }
      });
      final file = File(p.join(dir.path, 'locked.txt'))..writeAsStringSync('x');

      final blocked = await _makeUndeletable(dir.path);
      // Whether or not this platform (or user) honors the directory mode,
      // a failing cleanup must never throw out of the deletion helper.
      await deleteSourceFileQuietly(file.path);
      if (blocked) {
        expect(file.existsSync(), isTrue);
      }
    });
  });
}

/// Makes [dir] unwritable so that deleting files inside it fails.
///
/// Returns whether the restriction is actually in effect: POSIX only, and
/// only for non-root users (root ignores file modes).
Future<bool> _makeUndeletable(String dir) async {
  if (Platform.isWindows) {
    return false;
  }
  final id = await Process.run('id', ['-u']);
  if (id.stdout.toString().trim() == '0') {
    return false;
  }
  final result = await Process.run('chmod', ['500', dir]);
  return result.exitCode == 0;
}
