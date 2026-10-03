import 'dart:io';

import 'package:localsend_app/model/cross_file.dart';
import 'package:localsend_app/provider/selection/selected_sending_files_provider.dart';
import 'package:localsend_isolates/model/file_type.dart';
import 'package:localsend_isolates/rust/api/model.dart';
import 'package:localsend_isolates/rust/frb_generated.dart';
import 'package:path/path.dart' as p;
import 'package:refena_flutter/refena_flutter.dart';
import 'package:test/test.dart';

/// Tests for the directory enumeration behind [AddDirectoryAction].
///
/// In production, [AddDirectoryAction] offloads the enumeration to a
/// background isolate (Isolate.run) which initializes RustLib itself; the
/// Rust native library is not available inside `flutter test`, so these
/// tests call [enumerateDirectoryFiles] - the exact function the isolate
/// runs - directly, with RustLib in mock mode, and inject it into the
/// action to also cover the selection-merge (dedup) semantics.
void main() {
  setUpAll(() {
    RustLib.initMock(api: _FakeRustLibApi());
  });

  test('enumerates a directory tree recursively with sizes and metadata', () async {
    final root = await Directory.systemTemp.createTemp('ls_send_dir_test');
    addTearDown(() async {
      if (root.existsSync()) {
        await root.delete(recursive: true);
      }
    });

    final sub = Directory(p.join(root.path, 'sub'))..createSync();
    final nested = Directory(p.join(sub.path, 'nested'))..createSync();
    File(p.join(root.path, 'a.txt')).writeAsBytesSync([1, 2, 3]);
    File(p.join(sub.path, 'b.bin')).writeAsBytesSync([1, 2, 3, 4, 5]);
    File(p.join(nested.path, 'c.txt')).writeAsBytesSync(List.generate(7, (i) => i));
    Directory(p.join(root.path, 'empty')).createSync();

    final files = await enumerateDirectoryFiles(root.path);

    final rootName = p.basename(root.path);
    expect(
      files.map((f) => f.name).toSet(),
      {
        '$rootName/a.txt',
        '$rootName/sub/b.bin',
        '$rootName/sub/nested/c.txt',
      },
    );
    // The size of every file is collected (15k files only differ in scale).
    expect(files.fold<int>(0, (prev, f) => prev + f.size), 3 + 5 + 7);

    for (final file in files) {
      // The timestamps come from the (mocked) Rust readFileMetadata call.
      expect(file.lastModified, '2000-01-01T00:00:00Z');
      expect(file.lastAccessed, '2000-01-02T00:00:00Z');
      // Directory files never reference album assets or in-memory bytes,
      // which is what makes them sendable across isolate boundaries.
      expect(file.asset, isNull);
      expect(file.bytes, isNull);
      expect(file.thumbnail, isNull);
      // The path points to the real file.
      expect(File(file.path!).existsSync(), isTrue);
    }

    final byName = {for (final f in files) f.name: f};
    expect(byName['$rootName/a.txt']!.fileType, FileType.text);
    expect(byName['$rootName/sub/b.bin']!.fileType, FileType.other);
  });

  test('a nonexistent directory throws (error behavior unchanged)', () async {
    final nonexistent = p.join(Directory.systemTemp.path, 'ls_does_not_exist_${DateTime.now().millisecondsSinceEpoch}');
    await expectLater(enumerateDirectoryFiles(nonexistent), throwsA(isA<FileSystemException>()));
  });

  test('AddDirectoryAction appends the enumerated files to an empty selection', () async {
    final root = await Directory.systemTemp.createTemp('ls_send_action_test');
    addTearDown(() async {
      if (root.existsSync()) {
        await root.delete(recursive: true);
      }
    });

    final sub = Directory(p.join(root.path, 'sub'))..createSync();
    File(p.join(root.path, 'a.txt')).writeAsBytesSync([1, 2, 3]);
    File(p.join(sub.path, 'b.bin')).writeAsBytesSync([1, 2, 3, 4, 5]);

    final service = ReduxNotifier.test(
      redux: SelectedSendingFilesNotifier(),
    );
    await service.dispatchAsync(
      AddDirectoryAction(root.path, enumerateDirectory: enumerateDirectoryFiles),
    );

    final rootName = p.basename(root.path);
    expect(service.state, hasLength(2));
    expect(
      service.state.map((f) => f.name).toSet(),
      {
        '$rootName/a.txt',
        '$rootName/sub/b.bin',
      },
    );
    expect(service.state.fold<int>(0, (prev, f) => prev + f.size), 3 + 5);
    // The selection stays unmodifiable, as before.
    expect(
      () => service.state.add(
        CrossFile(
          name: 'x',
          fileType: FileType.other,
          size: 0,
          thumbnail: null,
          asset: null,
          path: null,
          bytes: null,
          lastModified: null,
          lastAccessed: null,
        ),
      ),
      throwsA(isA<UnsupportedError>()),
    );
  });

  test('AddDirectoryAction does not duplicate already selected files', () async {
    final root = await Directory.systemTemp.createTemp('ls_send_dedup_test');
    addTearDown(() async {
      if (root.existsSync()) {
        await root.delete(recursive: true);
      }
    });

    final aPath = p.join(root.path, 'a.txt');
    File(aPath).writeAsBytesSync([1, 2, 3]);
    File(p.join(root.path, 'b.txt')).writeAsBytesSync([1, 2, 3, 4]);

    final selectedA = CrossFile(
      name: 'elsewhere.txt',
      fileType: FileType.text,
      size: 0,
      thumbnail: null,
      asset: null,
      path: aPath,
      bytes: null,
      lastModified: null,
      lastAccessed: null,
    );
    final message = CrossFile(
      name: 'message.txt',
      fileType: FileType.text,
      size: 3,
      thumbnail: null,
      asset: null,
      path: null,
      bytes: [1, 2, 3],
      lastModified: null,
      lastAccessed: null,
    );

    final service = ReduxNotifier.test(
      redux: SelectedSendingFilesNotifier(),
      initialState: [selectedA, message],
    );
    await service.dispatchAsync(
      AddDirectoryAction(root.path, enumerateDirectory: enumerateDirectoryFiles),
    );

    // The existing selection comes first and is kept as-is;
    // only b.txt is new (a.txt is already selected via its path).
    expect(service.state, hasLength(3));
    expect(service.state[0], same(selectedA));
    expect(service.state[1], same(message));
    expect(service.state[2].name, '${p.basename(root.path)}/b.txt');
    expect(service.state.where((f) => f.path == aPath), hasLength(1));
  });
}

/// Provides deterministic [FileMetadata]s without the Rust native library.
class _FakeRustLibApi implements RustLibApi {
  @override
  Future<FileMetadata?> crateApiMetadataReadFileMetadata({required String path}) async {
    return const FileMetadata(modified: '2000-01-01T00:00:00Z', accessed: '2000-01-02T00:00:00Z');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnsupportedError('Not mocked: ${invocation.memberName}');
}
