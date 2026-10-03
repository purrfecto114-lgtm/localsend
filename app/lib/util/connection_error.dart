import 'package:localsend_isolates/rust/api/http.dart';
import 'package:localsend_isolates/util/rust.dart';

/// The kind of failure a connection attempt to another device had.
enum ConnectionErrorKind {
  /// The request timed out: the device is typically offline, asleep or
  /// blocked by a firewall (#2121).
  timeout,

  /// The connection was actively refused: nothing is listening on the
  /// target address and port, i.e. LocalSend is not running there
  /// (or is using a different port).
  connectionRefused,

  /// The device answered but rejected the request (HTTP 401/403):
  /// typically a PIN requirement or a changed pairing.
  forbidden,

  /// Any other failure.
  other,
}

/// Matches a 401/403 status in stringified errors, e.g. "[403] PIN required".
final _httpForbiddenStatusPattern = RegExp(r'\b40[13]\b');

/// Classifies an error thrown while connecting to another device
/// (manual address input, favorites) into an actionable kind.
ConnectionErrorKind classifyConnectionError(Object error) {
  if (error is RsHttpClientError_StatusCode) {
    if (error.status == 401 || error.status == 403) {
      return ConnectionErrorKind.forbidden;
    }
  }

  final message = error.humanErrorMessage.toLowerCase();
  if (message.contains('forbidden') || _httpForbiddenStatusPattern.hasMatch(message)) {
    return ConnectionErrorKind.forbidden;
  }
  if (message.contains('timed out') || message.contains('timeout')) {
    return ConnectionErrorKind.timeout;
  }
  if (message.contains('connection refused') || message.contains('connect refused')) {
    return ConnectionErrorKind.connectionRefused;
  }
  return ConnectionErrorKind.other;
}
