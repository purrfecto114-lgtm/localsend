import 'dart:io';

/// The kind of failure that prevented the server from starting.
enum StartupErrorKind {
  /// Windows denied access to the port (errno 10013 / WSAEACCES).
  ///
  /// Community-documented causes (#125, #2884): a port range excluded by
  /// Hyper-V, WSL or Docker covers the LocalSend port, or the Winsock
  /// catalog is broken (`netsh winsock reset` fixes that).
  windowsAccessDenied,

  /// The port is already used by another process:
  /// errno 98 (Linux EADDRINUSE), 48 (macOS EADDRINUSE) or
  /// 10048 (Windows WSAEADDRINUSE).
  addressInUse,

  /// Any other failure without a known errno.
  generic,
}

/// The classified result of a server start failure.
class StartupErrorClassification {
  final StartupErrorKind kind;

  /// The operating system error code extracted from the failure, if any.
  final int? errno;

  /// The raw error text for the "copy details" action and bug reports.
  final String detail;

  const StartupErrorClassification({
    required this.kind,
    required this.errno,
    required this.detail,
  });
}

/// errno values of the Windows "forbidden access" family (#125, #2884, #2746).
const _windowsAccessDeniedErrnos = {10013};

/// errno values meaning "the address is already in use" on the supported
/// platforms (Linux, macOS, Windows).
const _addressInUseErrnos = {98, 48, 10048};

/// Matches both shapes the error text can have:
/// - Dart `SocketException`: "(OS Error: ..., errno = 10013)"
/// - Rust anyhow chain (crosses the isolate boundary as a string):
///   "Address already in use (os error 98)"
final _errnoPattern = RegExp(r'(?:errno\s*=\s*|os error\s+)(\d+)');

/// Classifies a server start failure into an actionable kind.
///
/// The error may be a [SocketException] (direct Dart socket errors), a plain
/// [String] (the server isolate stringifies Rust errors before sending them
/// across the isolate boundary) or any other object; classification then
/// falls back to scanning the error text for an errno.
StartupErrorClassification classifyStartupError(Object error) {
  int? errno;
  if (error is SocketException) {
    errno = error.osError?.errorCode;
  }
  errno ??= int.tryParse(_errnoPattern.firstMatch(error.toString())?.group(1) ?? '');

  final StartupErrorKind kind;
  if (errno != null && _windowsAccessDeniedErrnos.contains(errno)) {
    kind = StartupErrorKind.windowsAccessDenied;
  } else if (errno != null && _addressInUseErrnos.contains(errno)) {
    kind = StartupErrorKind.addressInUse;
  } else {
    kind = StartupErrorKind.generic;
  }

  return StartupErrorClassification(
    kind: kind,
    errno: errno,
    detail: error.toString(),
  );
}
