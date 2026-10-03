import 'dart:io';

/// The kind of target the user entered in the manual address dialog.
enum ManualAddressType { ipv4, ipv6, hostname }

/// Why a manual address input was rejected.
enum ManualAddressError {
  /// The input contains an URI scheme like "http://".
  scheme,

  /// The input contains a ":port" suffix that the dialog cannot honor
  /// (the port always comes from the settings).
  port,

  /// Neither a valid IP address nor a valid host name.
  invalid,
}

/// A validated and normalized manual address.
class ManualAddress {
  final ManualAddressType type;

  /// The host to connect to, in normalized form:
  /// - IPv4: as returned by [InternetAddress.address]
  /// - IPv6: without brackets; Dart keeps the textual form as entered
  ///   (it does not compress or lowercase it), an optional zone id
  ///   ("fe80::1%3") is preserved
  /// - host name: lowercased, without a trailing dot
  final String host;

  const ManualAddress({required this.type, required this.host});
}

final _schemePattern = RegExp(r'^[a-zA-Z][a-zA-Z0-9+.-]*://');
final _hostPortPattern = RegExp(r'^([^:\s]+):(\d+)$');
final _labelPattern = RegExp(r'^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$');
final _allDigits = RegExp(r'^\d+$');

const _maxHostNameLength = 253;
const _maxLabelLength = 63;

/// Parses user input from the manual address dialog.
///
/// Returns `(<address>, null)` on success and `(null, <error>)` when the
/// input is rejected. Empty (or whitespace-only) input returns `(null, null)`:
/// there is nothing to show yet and the submit button stays disabled.
(ManualAddress?, ManualAddressError?) parseManualAddress(String raw) {
  final input = raw.trim();
  if (input.isEmpty) {
    return (null, null);
  }

  if (_schemePattern.hasMatch(input)) {
    return (null, ManualAddressError.scheme);
  }

  // Bare IPv4 / IPv6 literals (including scoped IPv6 like "fe80::1%3").
  final literal = InternetAddress.tryParse(input);
  if (literal != null) {
    return (
      ManualAddress(
        type: literal.type == InternetAddressType.IPv4 ? ManualAddressType.ipv4 : ManualAddressType.ipv6,
        host: literal.address,
      ),
      null,
    );
  }

  // Bracketed IPv6 ("[::1]"), the form browsers accept.
  if (input.startsWith('[')) {
    final hostPort = RegExp(r'^\[(.+)\]:(\d+)$').firstMatch(input);
    if (hostPort != null) {
      return (null, ManualAddressError.port);
    }
    final bracketMatch = RegExp(r'^\[(.+)\]$').firstMatch(input);
    if (bracketMatch != null) {
      final inner = bracketMatch.group(1)!;
      final innerAddress = InternetAddress.tryParse(inner);
      if (innerAddress != null && innerAddress.type == InternetAddressType.IPv6) {
        return (ManualAddress(type: ManualAddressType.ipv6, host: innerAddress.address), null);
      }
    }
    return (null, ManualAddressError.invalid);
  }

  // "host:port" and "192.168.1.2:53317": point at the port setting instead.
  final hostPort = _hostPortPattern.firstMatch(input);
  if (hostPort != null) {
    return (null, ManualAddressError.port);
  }

  if (_isValidHostName(input)) {
    final host = input.toLowerCase();
    return (
      ManualAddress(
        type: ManualAddressType.hostname,
        host: host.endsWith('.') ? host.substring(0, host.length - 1) : host,
      ),
      null,
    );
  }

  return (null, ManualAddressError.invalid);
}

/// RFC 1123 host name check: dot-separated labels of letters, digits and
/// hyphens that neither start nor end with a hyphen.
bool _isValidHostName(String input) {
  var host = input;
  if (host.endsWith('.')) {
    host = host.substring(0, host.length - 1);
  }
  if (host.isEmpty || host.length > _maxHostNameLength) {
    return false;
  }
  final labels = host.split('.');
  var sawNonNumericLabel = false;
  for (final label in labels) {
    if (label.isEmpty || label.length > _maxLabelLength || !_labelPattern.hasMatch(label)) {
      return false;
    }
    if (!_allDigits.hasMatch(label)) {
      sawNonNumericLabel = true;
    }
  }
  // "192.168.1" is neither a valid IPv4 address nor a resolvable name.
  if (!sawNonNumericLabel) {
    return false;
  }
  return true;
}

/// Builds the candidate list for hashtag input ("123" -> "192.168.2.123"):
/// only IPv4 local addresses have a meaningful prefix, and every prefix is
/// tried once regardless of how many interfaces share it.
List<String> buildHashtagCandidates(List<String> localIps, String input) {
  final seen = <String>{};
  final candidates = <String>[];
  for (final ip in localIps) {
    final address = InternetAddress.tryParse(ip);
    if (address == null || address.type != InternetAddressType.IPv4) {
      continue;
    }
    final prefix = address.address.split('.').take(3).join('.');
    if (seen.add(prefix)) {
      candidates.add('$prefix.$input');
    }
  }
  return candidates;
}
