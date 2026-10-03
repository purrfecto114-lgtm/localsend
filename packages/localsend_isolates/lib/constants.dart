/// The protocol version.
///
/// Version table:
/// Protocols | App (Official implementation)
/// ----------|------------------------------
/// 1.0       | 1.0.0 - 1.8.0
/// 1.0, 2.0  | 1.9.0 - 1.14.0
/// 1.0, 2.1  | 1.15.0 - 1.17.0
/// 2.2       | 1.18.0
const protocolVersion = '2.2';

/// The default http server port and
/// and multicast port.
const defaultPort = 53317;

/// The default discovery timeout in milliseconds.
/// This is the time the discovery server waits for responses.
/// If no response is received within this time, the target server is unavailable.
const defaultDiscoveryTimeout = 500;

/// The default multicast group should be 224.0.0.0/24
/// because on some Android devices this is the only IP range
/// that can receive UDP multicast messages.
const defaultMulticastGroup = '224.0.0.167';

/// The default maximum number of network interfaces covered by the smart
/// scan. If there are more interfaces, only the first ones are scanned or
/// the user needs to select one manually.
///
/// 5 instead of 3: multi-adapter desktop machines (ethernet + Wi-Fi + VPN +
/// virtual adapters) plus an active hotspot easily exceed 3 networks, which
/// would drop the hotspot subnet out of the automatic scan. Each interface
/// only costs a `/24` scan when the cheap stages (multicast and favorite
/// probes) found nothing, so the extra candidates are rarely paid for.
const defaultMaxInterfaces = 5;

/// The bounds for the user-configurable smart scan interface limit.
/// A value below 1 would make the smart scan never scan anything and a
/// huge value would make the subnet selection menu unreachable.
const minMaxInterfaces = 1;
const maxMaxInterfaces = 10;
