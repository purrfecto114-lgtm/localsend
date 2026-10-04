import 'package:flutter_test/flutter_test.dart';
import 'package:localsend_app/util/checksum_status.dart';
import 'package:localsend_isolates/model/session_status.dart';

/// Matrix tests for the checksum status derivation of the progress page
/// (mitigation for localsend/localsend#3441 / #3425): the display state is
/// derived from the session status, the receiver's verifyChecksums setting
/// and the checksums the sender attached to the transferred files.
void main() {
  group('checksumVerificationStatus (receiving sessions)', () {
    test('null for every session status except finished', () {
      for (final status in SessionStatus.values.where((s) => s != SessionStatus.finished)) {
        expect(
          checksumVerificationStatus(
            sessionStatus: status,
            verifyChecksums: true,
            receivedFileCount: 3,
            filesWithChecksumCount: 3,
          ),
          isNull,
          reason: '$status must not show a checksum line',
        );
      }
    });

    test('null when nothing was received (everything declined)', () {
      expect(
        checksumVerificationStatus(
          sessionStatus: SessionStatus.finished,
          verifyChecksums: true,
          receivedFileCount: 0,
          filesWithChecksumCount: 0,
        ),
        isNull,
      );
    });

    test('verified: verification on and every file carried a checksum', () {
      expect(
        checksumVerificationStatus(
          sessionStatus: SessionStatus.finished,
          verifyChecksums: true,
          receivedFileCount: 3,
          filesWithChecksumCount: 3,
        ),
        ChecksumVerificationStatus.verified,
      );
    });

    test('verified also holds for a single file', () {
      expect(
        checksumVerificationStatus(
          sessionStatus: SessionStatus.finished,
          verifyChecksums: true,
          receivedFileCount: 1,
          filesWithChecksumCount: 1,
        ),
        ChecksumVerificationStatus.verified,
      );
    });

    test('partiallyVerified: only some files carried a checksum', () {
      expect(
        checksumVerificationStatus(
          sessionStatus: SessionStatus.finished,
          verifyChecksums: true,
          receivedFileCount: 3,
          filesWithChecksumCount: 2,
        ),
        ChecksumVerificationStatus.partiallyVerified,
      );
    });

    test('notVerifiable: verification on but no file carried a checksum', () {
      expect(
        checksumVerificationStatus(
          sessionStatus: SessionStatus.finished,
          verifyChecksums: true,
          receivedFileCount: 3,
          filesWithChecksumCount: 0,
        ),
        ChecksumVerificationStatus.notVerifiable,
      );
    });

    test('disabled: verification off wins over present checksums', () {
      expect(
        checksumVerificationStatus(
          sessionStatus: SessionStatus.finished,
          verifyChecksums: false,
          receivedFileCount: 3,
          filesWithChecksumCount: 3,
        ),
        ChecksumVerificationStatus.disabled,
      );
    });

    test('disabled also when the sender attached nothing', () {
      expect(
        checksumVerificationStatus(
          sessionStatus: SessionStatus.finished,
          verifyChecksums: false,
          receivedFileCount: 3,
          filesWithChecksumCount: 0,
        ),
        ChecksumVerificationStatus.disabled,
      );
    });
  });

  group('attachedChecksumCounts (sending sessions)', () {
    test('null for every session status except finished', () {
      for (final status in SessionStatus.values.where((s) => s != SessionStatus.finished)) {
        expect(
          attachedChecksumCounts(
            sessionStatus: status,
            sentFileCount: 3,
            filesWithChecksumCount: 3,
          ),
          isNull,
          reason: '$status must not show a checksum line',
        );
      }
    });

    test('counts are passed through when at least one file has a checksum', () {
      expect(
        attachedChecksumCounts(
          sessionStatus: SessionStatus.finished,
          sentFileCount: 3,
          filesWithChecksumCount: 2,
        ),
        (withChecksum: 2, total: 3),
      );
    });

    test('all files with checksums are reported as n / n', () {
      expect(
        attachedChecksumCounts(
          sessionStatus: SessionStatus.finished,
          sentFileCount: 4,
          filesWithChecksumCount: 4,
        ),
        (withChecksum: 4, total: 4),
      );
    });

    test('null when no file carries a checksum (nothing to report)', () {
      expect(
        attachedChecksumCounts(
          sessionStatus: SessionStatus.finished,
          sentFileCount: 3,
          filesWithChecksumCount: 0,
        ),
        isNull,
      );
    });

    test('null when nothing was sent', () {
      expect(
        attachedChecksumCounts(
          sessionStatus: SessionStatus.finished,
          sentFileCount: 0,
          filesWithChecksumCount: 0,
        ),
        isNull,
      );
    });
  });
}
