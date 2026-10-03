# LocalSend 传输链路优化总报告
### 蓝牙辅助传输 · 双频/热点异常 · 2.4GHz 降级 · 双频智联加速 · 调用链与回归风险

**代码基线**：localsend/localsend `main` 分支，app `v1.18.2+64`（2026-10-03 经 codeload 拉取）
**报告结构**：Part A 蓝牙可行性 ｜ Part B 双频/热点异常 ｜ Part C 单频 2.4GHz 降级 ｜ Part D 双频智联加速 ｜ Part E 调用链与改一半风险 ｜ Part F 回归风险 ｜ Part G 落地顺序

---

## 摘要

| 议题 | 结论 |
|---|---|
| 蓝牙能加吗 | 能，架构已预留口子。但**只做 BLE 辅助发现**，别做蓝牙传文件 |
| LocalSend 是单频吗 | **不是**。全接口并发收发，"单频"判断不成立 |
| 双频为啥出错 | 4 个机制，其中 3 个是代码缺陷：socket 不重绑、单接口静默死亡、兜底扫描漏掉 `.1` 网段 |
| 2.4G 降级怎么办 | 应用层可做 4 项降级，核心是**降扫描并发 + 放宽超时** |
| 双频智联能加速吗 | **链路层白拿，应用层改代码收益极小**——因为同 SSID 双频是同一子网、同一 IP |
| 最大改动风险 | 加 `DeviceChannel` 变体会触发 **2 处 Rust 不可反驳 let 编译失败** + `target.ip!` 空断言崩溃 |

---

# Part A：蓝牙辅助传输

## A.1 先例：需求强烈、路线清晰、零实现

| 编号 | 主题 | 关键信息 |
|---|---|---|
| #144 | Bluetooth file transfer（2023-02） | 校园网 AP 隔离导致设备互不可见，最早的需求贴 |
| #427 | Discussing Bluetooth support（2023-04） | 维护者 Tienisto：**"the bluetooth API is not easy to work with. Especially not on iOS. If you have a prototype, feel free to share it."**；有人提议先支持 Android/Linux/Windows 放弃 iOS；也有人提出改用 **Wi-Fi Aware / NAN** |
| #850 | Feature request: Bluetooth Discovery（2023-11） | 已形成路线：**BLE 发现 → Wi-Fi Direct → 回退同网 Wi-Fi → 蓝牙直传**；确认 iOS 不支持 Wi-Fi Direct；有人称将以学士论文实现，未见产出 |
| #2924 | 蓝牙分发 LocalSend 安装包（2026-01） | 无网环境下让未安装的用户装上，蓝牙的另一种用法 |

**判断**：卡在**实现成本而非设计分歧**。提 issue 的边际价值很低，带原型 PR 才有用。

## A.2 行业先例：BLE 只做发现，绝不传数据

- **AirDrop**：BLE 广播哈希联系人标识 → 匹配成功才唤醒 AWDL → mDNS/DNS-SD 发现服务 → TLS → `Discover`/`Ask`/`Upload`。BLE 全程只做发现与身份初筛
- **Nearby Share / Quick Share**：BLE/GATT 服务发现 → Wi-Fi Direct 或热点建链 → TLS 1.3 传数据
- **Windows 就近共享**：BLE 广播心跳完成发现与握手 → 切 Wi-Fi Direct 隧道；**无 Wi-Fi Direct 时才回退蓝牙**
- **速度共识**：蓝牙 5.0 理论峰值约 2 MB/s，实际稳定 <1.2 MB/s；LocalSend 20–40 MB/s，1GB 文件差距是「25 秒 vs 15 分钟」

## A.3 源码证据：扩展点已被官方预留

`packages/core/src/discovery/store.rs:125`：

```rust
/// A channel a device is reachable on.
///
/// Only HTTP exists so far; other transports (e.g. WebRTC, Bluetooth) will
/// become further variants.
pub enum DeviceChannel {
    Http(HttpChannel),
}
```

注释**直接点名 Bluetooth**。周边结构已按多通道设计：

- `StatefulDevice.channels: HashMap<DeviceChannel, ChannelStatus>` —— 多通道共存
- `ChannelStatus::{Available, NotReachable}` —— 通道级健康度
- `get_ranked_channels()`（store.rs:97）—— 排序：可用性 → 是否 IPv6 → 最近确认时间
- `DiscoveryHandle::add_device()`（discovery/mod.rs:395）—— 注释写明「供 discovery 之外确认的设备使用」

**旁证**：WebRTC 通道已趟过一遍路——Rust 侧 `webrtc/webrtc.rs`(1428行) + `signaling.rs`(528行) 完整实现，Flutter 侧 `signaling_provider.dart` 有 `const webRTCEnabled = false;` 关着它。`SignalingChannel` 已是 Dart 侧 `DeviceChannel` 的第二个变体，**这就是现成模板**。

## A.4 平台硬约束

| 约束 | 影响 |
|---|---|
| iOS 不支持 Wi-Fi Direct（Apple 官方确认） | AirDrop 式路线在 iOS 上封死 |
| iOS 后台广播被折叠，local name 不广播，UUID 进 overflow 区 | 「后台可发现以便收文件」在 iOS 收益大减 |
| iOS 前台广播仅 28 字节（+scan response 10 字节且只放 local name） | 载荷塞不下设备信息，细节得靠 GATT 读 |
| Android 广播载荷硬上限 31 字节，超出报 `ADVERTISE_FAILED_DATA_TOO_LARGE` | 同上 |
| BLE 实际吞吐 1–2 MB/s | 做主通道会毁掉「跑满 Wi-Fi」的核心卖点 |

## A.5 落地分三层

- **L1（推荐先做）**：BLE 广播 Service UUID + 指纹短哈希，扫到后用现有 HTTP register 握手完成确认，传输链路完全不变。解决 AP 隔离/组播被禁/跨网段，不动安全模型
- **L2**：BLE 交换凭据引导建直连链路（Android/Windows/Linux 可行，iOS 只能跳转系统设置）
- **L3**：BLE GATT/L2CAP 直传小文件（<10MB）兜底。维护者本人不看好，iOS 后台几乎不可用，**投入产出比最低**

## A.6 实现层选型

蓝牙必须放 **Dart 侧**，不能进 Rust core：Rust 的 `btleplug` 是 host/central 模式为主，外围广播支持薄弱；而权限申请、系统设置跳转、前后台生命周期更适合插件层。`flutter_blue_plus` 覆盖 Android/iOS/macOS/Windows/Linux/Web，**与 LocalSend 全平台目标对齐**。

## A.7 风险

1. **隐私追踪**：常驻 BLE 广播泄露设备存在与身份，AirDrop 正因广播哈希联系人标识被指出可长期跟踪 → **标识符要轮换，别直接广播稳定 fingerprint**
2. **电量**：Android 端放前台服务并设超时自动停止
3. **iOS 预期要降低**：很可能只能「前台发送时扫描」
4. **绝不能绕过证书 pinning**：BLE 只负责发现，身份认证仍由 HTTP register 握手的证书指纹完成

---

# Part B：双频/热点传输异常

## B.1 先证伪：LocalSend 并不只用单频

| 环节 | 实际行为 | 证据 |
|---|---|---|
| 组播发送 | **每个非回环 IPv4 地址绑一个 socket**，逐个接口发 | `multicast/socket.rs:20-88`；注释原文 *"One socket per interface is required because a socket only sends on a single interface."* |
| 出口绑定 | `set_multicast_if_v4(&interface)` 逐个钉住出口 | `multicast/socket.rs:109-111` |
| 组播接收 | 每个 socket 一条独立 `receive_loop` | `multicast/mod.rs:290-297` |
| HTTP 服务端 | 绑 `0.0.0.0` 与 `[::]` 通配地址 | `http/server/mod.rs:230-238` |

## B.2 四个失效机制（按可能性排序）

### 机制 1 ⭐⭐⭐ 接口变化后 socket 永不重绑（代码缺陷）

组播 socket **只在启动时绑一次**。重绑路径只有两条：iOS 后台恢复（`main.dart:72`）、设置页手动「重启服务」（`settings_tab_controller.dart:149`）。

且 `local_ip_provider.dart:49-56` **Windows 被明确排除**在网络变化监听之外：

```dart
if (checkPlatform([TargetPlatform.windows])) {
  // https://github.com/localsend/localsend/issues/12
  // https://github.com/localsend/localsend/issues/78
} else {
  _subscription = Connectivity().onConnectivityChanged.listen(...);
}
```

Android 12+ 双频并发热点（DBS，AOSP *Wi-Fi AP/AP concurrency*）会把两个频段桥接成**单个接口**，但**空闲频段会被框架自动关闭** [citation:4]。频段上下线 = 接口 churn。

**触发**：先开 LocalSend 再开热点 / 频段自动切换 / 频段引导漂移 / 双频合一重连换 IP → socket 还绑在旧口 → 新链路两端互不可见。

### 机制 2 ⭐⭐⭐ 单接口静默死亡（代码缺陷）

```rust
const MAX_CONSECUTIVE_RECEIVE_ERRORS: u32 = 10;   // multicast/mod.rs:58
```

某接口连续 10 次收错就 `return`，**永久放弃且不重建**。而 `MulticastEvent::SocketsFailed` 只在**全部** socket 挂掉才发（`multicast/mod.rs:301`）。

**表现**：干扰更重的 2.4G 先抖死，用户看到「设备时有时无」，日志只有一条 warn。

### 机制 3 ⭐⭐ TTL=1 跨不过三层边界

`set_multicast_ttl_v4(1)`（`socket.rs:118`）。设计本身正确（发现仅限本地链路），但部分路由器/热点把 2.4G 与 5G 划进不同 VLAN/子网或开 AP 隔离时就过不去。官方 troubleshooting 第一条即「关闭 AP 隔离」，并明确 Windows 需设为专用网络。

**注意**：AOSP 的桥接软 AP 是**二层桥接、同一子网** [citation:4]，TTL=1 没问题 → 这条主要命中**路由器**和 **Windows 移动热点**，不是 Android 手机热点。

### 机制 4 ⭐⭐ 兜底扫描覆盖不到热点网段（专门命中「开热点的那台设备」）

组播失效靠 `/24` 扫描兜底（`discovery/mod.rs:342`），但 Dart 侧只喂前 3 个：

```dart
static const maxInterfaces = 3;                    // scan_facade.dart:22
final networkInterfaces = ref.read(localIpProvider).localIps.take(maxInterfaces).toList();
```

排序规则（`local_ip_provider.dart:129-136`）：

```dart
int scoreA = a == primary ? 10 : (a.endsWith('.1') ? 0 : 1);
```

**以 `.1` 结尾排最后**——而热点主机 IP 恰恰是 `192.168.43.1`(Android)、`192.168.137.1`(Windows)、`172.20.10.1`(iOS)，全是 `.1`。

**后果**：开热点的 Windows 机器若还有以太网、VPN、VMware/WSL 虚拟网卡，热点网段进不了前 3 → 兜底不扫 → 组播一失效就全盘失联。**这正好解释"为什么偏偏是开热点的那台出问题"**。

## B.3 排查顺序

1. 设备列表能否互见？看不到=发现层（机制1/2/3/4）；看得到但传输出错→看传输层
2. 确认同子网（192.168.43.x / 172.20.10.x 同一段）
3. 强制同频：关掉双频合一，拆成 `XXX` 与 `XXX-5G`，两端连同一个
4. 关 AP 隔离；Windows 改专用网络
5. **验证机制 1**：开热点前先启 LocalSend，出问题后点一次「重启服务」，立刻恢复即命中
6. 看日志里 `Network state:` 输出的 `localIps` 是否含热点网段

## B.4 修复建议

| # | 改动 | 位置 | 说明 |
|---|---|---|---|
| 1 | Windows 也订阅网络变化，或轮询接口集合，变化时 dispatch `IsolateDiscoveryRestartAction` + `FetchLocalIpAction` | `local_ip_provider.dart:49` | 解决机制 1。用「接口集合变化才触发」的节流规避 #12/#78 |
| 2 | `IsolateDiscoveryRestartAction` 从 iOS 专属扩展到所有平台 `resumed` | `main.dart:63-74` | 改动最小 |
| 3 | `.1` 规则加例外（本机为热点网关时不排最后），或 `maxInterfaces` 3→更大 | `local_ip_provider.dart:129`、`scan_facade.dart:22` | 解决机制 4 |
| 4 | 单接口失败也上报，UI 提示「某网卡发现异常」并支持单接口重建 | `multicast/mod.rs:301-310` | 解决机制 2 |
| 5 | 周期用 `discover_known_http_channels` 探测收藏设备 | `discovery/mod.rs:272` | 已有现成 API |

---

# Part C：单频 2.4GHz 降级处理

## C.1 资料支撑：2.4G 的真实天花板

| 指标 | 数据 | 出处 |
|---|---|---|
| 802.11n 2.4G 实际吞吐 | **30–100 Mbps（约 4–12 MB/s）**，多数场景 40–70 Mbps | [citation:20][citation:12] |
| 家用环境优化后上限 | 全力优化 50–70 Mbps 已属优秀；<20 Mbps 需改信道 | [citation:12] |
| 40MHz 频宽回落 | 检测到非 Wi-Fi 干扰（微波炉/蓝牙/旧安防）**强制 40MHz→20MHz，直接砍半** | [citation:4-旧][citation:16] |
| 非重叠信道 | 2.4G 仅 **1/6/11** 三个互不重叠信道 | [citation:16] |
| MAC 层效率 | 有效载荷通常只有物理速率的 40%–60% | [citation:16] |
| 干扰实测 | 城市公寓 2.4G 信道占用率可达 87%；>8 个同信道 AP 时速率衰减超 50% | [citation:8] |

**换算到 LocalSend**：2.4G 单频下实际可用约 **5–9 MB/s**，相比 5GHz 的 20–40 MB/s 是 **3–5 倍差距**，且**抖动大**——802.11n 在高重传下 CSMA/CA 竞争可导致 40% 以上数据包重传。

## C.2 应用层降级策略（4 项，均可在现有代码落地）

### 降级 1 ⭐⭐⭐ 降低子网扫描并发（最高优先）

```rust
const SCAN_CONCURRENCY: usize = 50;        // discovery/mod.rs:33
```

`/24` 扫描会并发发起 **255 个** HTTP register 探测。在 5GHz 上无感，但在 40–70 Mbps 且重传率高的 2.4G 上，**这 255 个并发探测本身就是一次流量风暴**，会加剧 CSMA/CA 竞争、推高重传，反过来让发现更慢——**形成正反馈恶化**。

**建议**：检测到低速链路时把并发降到 8–16，并考虑分时发送而非 `buffer_unordered` 一次性铺开。

### 降级 2 ⭐⭐⭐ 放宽发现超时

```rust
pub const DEFAULT_DISCOVERY_TIMEOUT: Duration = Duration::from_millis(500);  // discovery/mod.rs:26
```

500ms 在 5GHz LAN 合理（注释写明"LAN peers answer quickly or not at all"），但 2.4G 高抖动下 RTT 尾巴很长，容易把本来可达的 peer 判死。

**建议**：低速链路下放宽到 1500–2000ms。注意该常量同时约束「单个无响应主机拖慢扫描」的时间（`discovery/mod.rs:71` 注释），所以要配合降级 1 一起调，否则扫描总时长会爆炸。

### 降级 3 ⭐⭐ 组播公告节奏适配

```rust
const ANNOUNCE_DELAYS: [Duration; 3] = [100ms, 500ms, 2000ms];   // multicast/mod.rs:45
```

三次重试是为抗丢包。2.4G 丢包率更高，理论上需要更多次；但每次公告是全接口广播，在弱链路上代价不小。

**建议**：不要在 2.4G 上盲目增加次数，而是**保持 3 次但把退避拉长**（如 200ms/800ms/3000ms），给链路恢复留时间。

### 降级 4 ⭐⭐ UI 提示与预期管理

`device_list_tile.dart` 已有条件渲染能力。建议在检测到低速链路时提示「当前为 2.4GHz 链路，传输速度受限」，并在传输页显示实时速率。

**注意**：40MHz→20MHz 回落是**路由器/驱动行为，应用层无法干预**，只能在 UI 上引导用户（切 5G、固定 20MHz 频宽反而更稳 [citation:16]、避开微波炉/蓝牙）。

## C.3 一个反直觉的建议

**2.4G 下建议把频宽固定为 20MHz 而非 40MHz** [citation:16]。40MHz 虽提升理论速率，但占用更多频谱、在拥堵环境更易触发强制回落，稳定性反而更差。对 LocalSend 这种大文件持续传输，**稳定 20MHz 优于抖动 40MHz**。

---

# Part D：双频智联加速

## D.1 资料支撑：三种"双频加速"的区别

| 技术 | 机制 | 实测/标称数据 | 出处 |
|---|---|---|---|
| **Wi-Fi 7 MLO** | 链路层多链路聚合，STA 与 AP 在 2.4G+5G(+6G) 同时建链 | 2.4G@40MHz 688Mbps + 5G@160MHz 2882Mbps = **3570Mbps** 标称；STR 实测 **747 Mbps vs 关 MLO 506 Mbps** | [citation:1][citation:13][citation:21] |
| **华为 Link Turbo / 四网协同** | 系统级 MP-ATP 协议，2.4G+5G 双 Wi-Fi + 双蜂窝并发 | 官方：理想环境下载速度比单 Wi-Fi 提升 135%、比单 4G 提升 71%；开启后下载快 41% | [citation:10][citation:6][citation:14] |
| **Band Steering / Smart Connect** | 路由器把双频合并为单 SSID 并引导设备选频 | **不增加带宽**，只是选频 | [citation:19] |

## D.2 关键判断：LocalSend 层面能看到"双频"吗？

这是本节最重要的结论——**绝大多数情况下看不到**。

**情形 1：同 SSID 双频（最常见）**
路由器把 2.4G 和 5G 桥接为**同一子网**（AOSP 的桥接软 AP 也明确是 "a single bridged interface" [citation:4]）。设备只拿到**一个 IP**。

→ LocalSend 的 `StatefulDevice.channels` 只有**一条** HTTP 通道。
→ MLO 在**链路层**生效，LocalSend **无需改代码，自动受益**。
→ 但 2.4G+5G 的 MLO 聚合收益有限：2.4G 干扰大且只有 688Mbps 标称，实测增益远不如 5G+5G 或 5G+6G [citation:5][citation:9]。真实环境双频并发提升约 40%–65% [citation:9]。

**情形 2：双频跨网段（部分路由器分 VLAN）**
设备可能通过不同频段拿到**两个 IP**。

→ LocalSend 现有多通道机制**天然能收集到两条**（`channels` 是 HashMap，按 endpoint 合并）。
→ **但 `get_ranked_channels()`（store.rs:97）只取排序最好的一条用**，没有并行聚合。
→ 这才是**唯一值得改代码的加速点**。

**情形 3：双 Wi-Fi 加速（Link Turbo 类）**
需要系统级协议栈支持（MP-ATP）且需端云协同 [citation:10][citation:14]，**第三方应用无法直接调用**。LocalSend 无能为力。

## D.3 结论与建议

1. **不要为了"双频加速"改 LocalSend 代码**——主流场景是情形 1，收益由链路层白拿，改了也没用
2. **真正值得做的**是情形 2 的「跨网段双通道并行传输」：当 `channels` 有 ≥2 条可用 HTTP 通道时，把文件分片并行推送。但这是较大改造，需解决分片调度、断点续传、接收端写入冲突
3. **性价比最高的其实是修 Part B 的缺陷**——让 5G 链路稳定可用，比在 2.4G 上折腾聚合收益大得多
4. 若用户问「为什么我的 WiFi 7 没变快」：检查是否 2.4G+5G MLO（收益有限），理想是 5G+5G/5G+6G 且需路由器与终端**双方**支持 [citation:5]

---

# Part E：调用链全景与「改一半」风险清单

## E.1 五条主链路

### 链路 A：发现启动
```
init.dart:191 IsolateSetupAction
  → ParentIsolateState.initial(SyncState{...})        init.dart:170-186
  → child/main.dart:48 syncProvider.overrideWithNotifier
  → child/main.dart:77 UpdateSyncStateAction           (每条消息携带 syncState)
  → discovery_isolate.dart DiscoveryListenTask
  → discovery.dart DiscoveryService.startListener()    :35
  → _runListener()  while(true)                        :58
  → startDiscovery(...)  rust bridge
  → api/discovery.rs start_discovery()
  → localsend::discovery::start()
  → multicast::start() → socket::bind_multicast_sockets() → local_interfaces()
```

### 链路 B：重绑（Part B 修复的核心）
```
触发点（全仓库仅 2 处）：
  main.dart:72                     ← iOS AppLifecycleState.resumed
  settings_tab_controller.dart:149 ← 设置页「重启服务」
  ↓
parent/actions.dart:169 IsolateDiscoveryRestartAction
  → connection.sendToIsolate(DiscoveryRestartTask)
  → discovery_isolate.dart:126 → DiscoveryService.restartListener()  discovery.dart:118
  → discovery.stop()  → listen stream 结束
  → _runListener 的 while(true) 下一轮重新 startDiscovery（重绑 socket）
```

**⚠️ 改一半风险 B-1**：`restartListener()` 依赖 `_discovery` 非空；若启动曾失败，走 `_retryCompleter` 分支（discovery.dart:124-127）。新增触发点时必须保证**两条分支都覆盖**，否则启动失败过的实例永远唤不醒。

**⚠️ 改一半风险 B-2**：`_listening` 标志（discovery.dart:30）使 `startListener()` 只首次生效，重绑完全依赖 `while(true)` 内部循环。**不要在外部重复调用 `startListener()`**。

**⚠️ 改一半风险 B-3**：`_restartRequested` 标志区分「主动重启」与「socket 意外失败」（discovery.dart:109-117）。新增自动重绑时要正确设置该标志，否则会误触发 1 秒退避延迟。

**⚠️ 改一半风险 B-4**：`RUNNING_DISCOVERY` 静态量（api/discovery.rs:141）用于清理热重启遗留实例。频繁自动重绑会放大这里的竞态。

### 链路 C：IP 排序 → 兜底扫描
```
local_ip_provider.dart FetchLocalIpAction
  → _getIp()  :82
      ├─ NetworkInfo().getWifiIP()          (thirdPartyResult)
      └─ getNetworkInterfaces(whitelist/blacklist) → 过滤 → 排除 IPv6 (:101)
  → rankIpAddresses(nativeResult, ip)       :109  ← ⚠️ .1 排最后
  → state.localIps
  ↓
scan_facade.dart StartSmartScan:22  localIps.take(3)     ← ⚠️ 只取前 3
  → StartStagedScan(favorites, interfaces, port, https, grace:1s)
  → IsolateDiscoveryStagedScanAction
  → DiscoveryStagedScanTask → discover_staged()
  → api/discovery.rs discover_staged() → DiscoveryHandle::discover_staged()
      ├─ discover_known_http_channels()   (收藏夹探测)
      ├─ sleep(grace=1s)
      └─ 无确认 → scan_subnet() × N       (并发 50，255 个探测)
```

**⚠️ 改一半风险 C-1**：`rankIpAddresses` 是**顶层函数**（非私有），被 `network_info_provider_test.dart` 直接测试。改排序会直接打红测试。

**⚠️ 改一半风险 C-2**：`maxInterfaces = 3` 与排序规则是**两个独立修复点**，只改一个不够。

### 链路 D：设置同步
```
settingsProvider.networkWhitelist / networkBlacklist / port / https / multicastGroup
  → init.dart:170-186 SyncState（仅初始化时构造一次）
  → child/main.dart:77 UpdateSyncStateAction（随每条消息下发）
  → discovery.dart:60 _ref.read(syncProvider) → Rust InterfaceFilter
```

**⚠️ 改一半风险 D-1**：SyncState 在 `init.dart` 里**只构造一次**，后续设置变更通过 `sendToIsolate` 的 `syncState` 字段下发。**改网络过滤相关设置后必须确认同步链路真的触发了**，否则改了设置但 Rust 侧还是旧 filter。

### 链路 E：设备确认 → 传输
```
Rust store → DiscoveryEvent → api/discovery.rs listen() → rs_stored_device()
  → RsStoredDevice.channels（已按 get_ranked_channels 排序）
  → rust.dart:137 toDevice()  → Device{ ip: best.host, channels: [...] }
  → nearby_devices_provider.dart RegisterDeviceAction
  → send_provider.dart:263 / :733  target.ip!        ← ⚠️ 非空断言
```

## E.2 加 `DeviceChannel` 变体的编译期陷阱（Part A 的硬风险）

新增 `Bluetooth(BluetoothChannel)` 后，以下位置**必须同步处理**：

| # | 位置 | 问题 |
|---|---|---|
| 1 | `store.rs:135` `http()` | match 需补分支 |
| 2 | `store.rs:143` `same_endpoint()` | match 需补分支 |
| 3 | `store.rs:150` `is_ipv6()` | match 需补分支 |
| 4 | **api/discovery.rs `rs_device_log()`** | `let DeviceChannel::Http(http) = log.channel;` —— **不可反驳 let，无 fallback，加变体直接编译失败** |
| 5 | **api/discovery.rs `rs_stored_device()`** | `let DeviceChannel::Http(http) = channel;` —— 同上 |
| 6 | `device.dart:100` `transmissionMethods` | switch 需补分支（Dart sealed class 会报穷尽性错误） |
| 7 | `rust.dart:137` `toDevice()` | `final best = channels.first; ip: best.host` —— **蓝牙通道没有 host，`channels.first` 取到蓝牙则直接错** |
| 8 | **`send_provider.dart:263` / `:733`** | `target.ip!` —— **蓝牙设备 ip 为 null，非空断言直接崩溃** |
| 9 | `favorite_device.dart:16` | `final String ip;` **强制非空**，收藏蓝牙设备需要改模型 |
| 10 | `DeviceLog.channel` (device.dart:56) | 类型是**具体 `HttpChannel`** 而非 `DeviceChannel`，需泛化 |
| 11 | `RsDeviceChannel` / `DeviceChannel` Dart 侧 | 字段只有 host/port/protocol，**蓝牙通道需要新字段** |
| 12 | `device_list_tile.dart:64` | 已有 `if (device.ip != null)` 判空，是**唯一已就绪**的地方 |

**结论**：真正会「改一半」的是 **#4/#5（Rust 编译失败）+ #7/#8（运行时崩溃）**。这四处必须第一批改完。

---

# Part F：回归风险清单（测试）

| 测试文件 | 覆盖内容 | 改动后的风险 |
|---|---|---|
| `app/test/unit/provider/network_info_provider_test.dart` | 直接测 `rankIpAddresses`，含 `'222.1'` 排最后的断言 | **改排序必红**，需同步更新用例 |
| `app/test/unit/util/network_interfaces_test.dart` | 白/黑名单匹配 | 改 filter 逻辑需回归 |
| `packages/core/tests/discovery.rs` | 端到端发现，真实 HTTP server | 改 `DeviceChannel` / 扫描逻辑必跑 |
| `packages/core/tests/multicast.rs` | 真实组播流量 | 改 socket 绑定必跑 |
| `packages/core/tests/event_backpressure.rs` | **CHANNEL_CAPACITY = 16**，验证事件发射不阻塞 | 改并发/扫描会改变事件爆发密度，**高风险** |
| `packages/core/tests/accept_resilience.rs` | accept 循环健壮性 | 改 server 绑定需跑 |
| `packages/core/tests/v2_tls_pinning.rs` | TLS 证书 pinning | **Part A 安全模型相关，必跑** |

**额外提醒**：`event_backpressure.rs:29` 注释写明 isolate 层两个事件通道容量都是 **16**；而 `discovery/mod.rs:29` 的 `MULTICAST_CHANNEL_SIZE = 64`。**降低扫描并发（降级 1）会改变事件到达节奏**，这个测试是直接的回归探针。

---

# Part G：落地顺序建议

| 阶段 | 内容 | 理由 |
|---|---|---|
| **P0** | 修 Part B 机制 1/4：Windows 网络变化监听 + 全平台 `resumed` 重绑 + `.1` 排序例外 | 改动小、收益直接、解决用户实际抱怨的问题 |
| **P1** | 修 Part B 机制 2：单接口失败上报 + 单接口重建 | 消除静默失效，需动 Rust 与 Dart 两侧 |
| **P2** | Part C 降级 1/2：扫描并发与超时按链路质量自适应 | 需先有链路质量探测手段 |
| **P3** | Part A L1：BLE 辅助发现（仅 Android + 桌面端原型） | 先做原型再开 PR，符合维护者「有原型就拿来」的立场 |
| **不做** | Part D 双频智联应用层改造 | 主流场景由链路层白拿，改代码收益极小 |
| **不做** | Part A L3 蓝牙直传 | 维护者不看好，iOS 后台不可用 |

---

## 参考出处

- LocalSend 官方 issue/discussion：#144、#427、#850、#2924
- AirDrop 协议逆向：USENIX Sec'19（AWDL 与 AirDrop 逆向）；arXiv 2606.26967（AirDrop 与 Quick Share 近场传输协议系统性研究）
- 平台能力：Apple《Best Practices for Setting Up Your Local Device as a Peripheral》（广播字节限制与后台行为）；Google `android-BluetoothAdvertisements` 官方示例（31 字节上限）
- 双频热点：AOSP《Wi-Fi AP/AP concurrency》（DBS 桥接软 AP 与空闲频段自动关闭）[citation:4]
- 单频 2.4G：802.11n 实际吞吐 30–100 Mbps [citation:20]；家用优化后 40–70 Mbps [citation:12]；40MHz→20MHz 强制回落与 20MHz 更稳的建议 [citation:16]；非重叠信道仅 1/6/11 [citation:16]
- 双频加速：Wi-Fi Alliance《Wi-Fi CERTIFIED 7》MLO 章节 [citation:1]；2.4G@40+5G@160=3570Mbps 标称 [citation:5][citation:13]；STR 实测 747 vs 506 Mbps [citation:21]；真实环境提升 40%–65% [citation:9]；华为 Link Turbo / 四网协同 [citation:6][citation:10][citation:14]；Band Steering 不增加带宽且 IoT 设备易受影响 [citation:19]
- 本地化参考资料：LocalSend 官方 troubleshooting（AP 隔离、Windows 专用网络）
