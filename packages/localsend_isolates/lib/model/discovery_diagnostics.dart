/// A snapshot of the discovery service state, pulled on demand to diagnose
/// why no nearby device was found.
///
/// Pure data (bool/String/DateTime/int) so it safely crosses the isolate
/// port (deep copy); the Rust objects it was derived from stay behind.
class DiscoveryDiagnostics {
  /// Whether the Rust discovery is currently bound, i.e. announcements can
  /// be sent and (with multicast) heard.
  final bool running;

  /// The aggregated reason the multicast sockets could not be bound, when
  /// they could not: the discovery then runs without multicast and can
  /// neither hear nor send announcements. null when multicast is fine (or
  /// unknown because the discovery is not bound).
  final String? multicastError;

  /// When the discovery was last successfully bound; null when it never was.
  final DateTime? boundAt;

  /// How many announcements were sent since the isolate started.
  final int announcementsSent;

  /// How many `/24` subnet scans reached the discovery since the isolate
  /// started (requested scans while the discovery was not running do not
  /// count).
  final int subnetScansRequested;

  /// How many staged scans (announcement + favorite probes + subnet scan
  /// fallback) reached the discovery since the isolate started.
  final int stagedScansRequested;

  /// How many times the listen stream ended unexpectedly because the
  /// multicast sockets failed; the service rebinds after a short delay.
  final int unexpectedRestarts;

  /// How many device confirmations arrived on the listen stream since the
  /// isolate started (including re-confirmations of known devices).
  final int deviceConfirmations;

  const DiscoveryDiagnostics({
    required this.running,
    required this.multicastError,
    required this.boundAt,
    required this.announcementsSent,
    required this.subnetScansRequested,
    required this.stagedScansRequested,
    required this.unexpectedRestarts,
    required this.deviceConfirmations,
  });
}
