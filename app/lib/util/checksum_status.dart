import 'package:localsend_isolates/model/session_status.dart';

/// What the progress page reports about the checksum verification of a
/// finished *receiving* session.
///
/// This is a low-cost mitigation for localsend/localsend#3441 (files arrived
/// corrupted but the transfer was reported as successful) and #3425
/// (checksums made transfers fail): surfacing the verification state tells
/// the receiver whether the integrity of the received files was actually
/// checked, instead of leaving checksums as an invisible background feature.
enum ChecksumVerificationStatus {
  /// The receiver verifies checksums and every received file carried the
  /// sender's SHA-256: the integrity of every file has been checked.
  ///
  /// The verification itself happens in the Rust server: a mismatch fails
  /// the file, so a session that finished without errors means every file
  /// that carried a checksum was verified successfully.
  verified,

  /// The receiver verifies checksums but only some received files carried
  /// the sender's SHA-256: the integrity of the other files could not be
  /// checked (the protocol allows sending files without a checksum, e.g.
  /// when the sender cannot calculate it).
  partiallyVerified,

  /// The receiver verifies checksums but none of the received files carried
  /// one (old app versions or third-party clients may omit them):
  /// nothing was checked.
  notVerifiable,

  /// Checksum verification is disabled in the receiver settings.
  disabled,
}

/// Derives the checksum verification status shown for a *receiving* session
/// on the progress page.
///
/// Returns `null` when no checksum line should be shown at all:
/// - only cleanly finished sessions get a line: [SessionStatus.finishedWithErrors]
///   keeps the existing per-file error display (a failed checksum
///   verification is a file error and therefore already visible), and
///   canceled or in-flight sessions have no meaningful verification state;
/// - sessions without any received file (everything was declined).
ChecksumVerificationStatus? checksumVerificationStatus({
  required SessionStatus sessionStatus,
  required bool verifyChecksums,
  required int receivedFileCount,
  required int filesWithChecksumCount,
}) {
  if (sessionStatus != SessionStatus.finished || receivedFileCount == 0) {
    return null;
  }
  if (!verifyChecksums) {
    return ChecksumVerificationStatus.disabled;
  }
  if (filesWithChecksumCount == 0) {
    return ChecksumVerificationStatus.notVerifiable;
  }
  if (filesWithChecksumCount < receivedFileCount) {
    return ChecksumVerificationStatus.partiallyVerified;
  }
  return ChecksumVerificationStatus.verified;
}

/// The checksum attachment counts shown for a finished *sending* session:
/// how many of the sent files carry the SHA-256 the receiver can verify.
///
/// Returns `null` when the line should not be shown: the session is not
/// [SessionStatus.finished] (errors are already visible per file), nothing
/// was sent, or no file carried a checksum (there is nothing to report to
/// the sender).
({int withChecksum, int total})? attachedChecksumCounts({
  required SessionStatus sessionStatus,
  required int sentFileCount,
  required int filesWithChecksumCount,
}) {
  if (sessionStatus != SessionStatus.finished || sentFileCount == 0 || filesWithChecksumCount == 0) {
    return null;
  }
  return (withChecksum: filesWithChecksumCount, total: sentFileCount);
}
