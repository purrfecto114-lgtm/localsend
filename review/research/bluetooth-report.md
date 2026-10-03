# 蓝牙（BLE）在 LocalSend 场景下的技术切合度评估与集成设计建议

> Task ID: 36-b / Agent: RESEARCH-B / 日期：2026-10-03
> 范围：只调研写报告，不改仓库。评估"蓝牙辅助发现 + 蓝牙传输文件"对 LocalSend（HTTP over IP + UDP multicast 发现，协议 v2，上游基线 9529e915 / app 1.18.2+64）的切合度，并给出推荐集成设计。
> 所有技术断言均附来源链接（编号 [S#]，清单见 §1）。

---

## 1. 调研方法与来源清单

方法：z-ai web_search（英文为主）多轮检索 + page_reader/curl 抓取正文 + GitHub API（`search/issues`、issue/PR 详情、raw README）交叉验证；本地仓库只读核对代码接缝（`discovery.dart` / `device.dart` / `pubspec.yaml`）。

| # | 来源 | 链接 |
|---|------|------|
| S1 | LocalSend issue #850 Bluetooth Discovery（open，51👍，27 评论） | https://github.com/localsend/localsend/issues/850 |
| S2 | LocalSend issue #144 Bluetooth file transfer（open，35👍） | https://github.com/localsend/localsend/issues/144 |
| S3 | 相关 issue：#2872（BLE 自动发现）、#2281（类 AirDrop ad-hoc，12👍）、#2591（WiFi Direct，closed=dup）、#1122（ Nearby Share 协议集成，closed）、#189（WiFi Direct+QR，open，64👍） | https://github.com/localsend/localsend/issues/189 等 |
| S4 | LocalSend PR #3250 android: companion-device bluetooth association（2026-08-07 提交，维护者回复 "AI slop" 后当日关闭，未合并） | https://github.com/localsend/localsend/pull/3250 |
| S5 | flutter_blue_plus pub.dev 主页（v2.3.14，9 小时前发布；License=unknown；central-only） | https://pub.dev/packages/flutter_blue_plus |
| S6 | flutter_blue_plus changelog（2.0.0 换 FlutterBluePlus License；2.1.0 商业授权 15 人起；2.3.5 构建期 license ping；2.3.9 Corporate tier + 包名改 com.jmx；2.3.14 global tier） | https://pub.dev/packages/flutter_blue_plus/changelog |
| S7 | flutter_blue_plus v1.36.8 版本页（BSD-3-Clause，2025-09-17 发布 = 最后一个 BSD 版本） | https://pub.dev/packages/flutter_blue_plus/versions/1.36.8 |
| S8 | bluetooth_low_energy（v6.2.1，MIT，publisher zeekr.dev；central 5 平台 + peripheral 4 平台 API 矩阵） | https://pub.dev/packages/bluetooth_low_energy ；https://github.com/yanshouwang/bluetooth_low_energy |
| S9 | flutter_reactive_ble（v5.6.0，BSD-3，publisher meethue.com，仅 Android+iOS） | https://pub.dev/packages/flutter_reactive_ble |
| S10 | flutter_ble_peripheral（v3.1.0，BSD-3；README 详述各平台广播限制/后台广播/GATT server） | https://pub.dev/packages/flutter_ble_peripheral ；https://github.com/juliansteenbakker/flutter_ble_peripheral |
| S11 | flutter_bluetooth_serial（v0.4.0，5 年前发布，仅 Android，RFCOMM/SPP；fluttergems 标注 Maintenance Status: Poor） | https://pub.dev/packages/flutter_bluetooth_serial ；https://fluttergems.dev |
| S12 | Android 官方蓝牙权限文档（Android 12+ BLUETOOTH_SCAN/ADVERTISE/CONNECT、neverForLocation、legacy 权限 maxSdk=30） | https://developer.android.com/develop/connectivity/bluetooth/bt-permissions |
| S13 | Apple Core Bluetooth 后台处理文档（后台广播：local name 丢弃、service UUID 进 overflow 区、频率下降） | https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothBackgroundProcessingForiOSApps/PerformingTasksWhileYourAppIsInTheBackground.html |
| S14 | Microsoft [MS-CDP] 官方协议（Windows "Nearby Sharing" 底层）：§2.1 Transport=BLE/Bluetooth/LAN/WiFi Direct；§2.2.2.2.3 BLE Advertising Beacon（30 字节 mfg data=24B beacon data=salt+19B Device_Hash），2024-10-30 更新 | https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-cdp/3e6be5e8-e315-4f4b-97c7-ec0045d9bbb9 |
| S15 | PrivateDrop（USENIX Security '21，Heinrich 等，TU Darmstadt）+ arXiv 1604.06959：AirDrop = BLE 广播联系信息哈希 → 匹配后经 AWDL 上的 mDNS 广告 instance name + AWDL IP + port → HTTPS over AWDL 传文件（不经蓝牙） | https://www.usenix.org/conference/usenixsecurity21/presentation/heinrich ；https://arxiv.org/abs/1604.06959 |
| S16 | Nordic 官方：Bluetooth 5（2M PHY 应用层吞吐最高 1.4 Mbps）+ Nordic Academy（Max application data throughput 1.4 Mbps） | https://www.nordicsemi.com/Products/Wireless/Bluetooth-Low-Energy/Bluetooth-5 |
| S17 | Argenox《Bluetooth 6 Speed: Guide to Maximizing BLE Data Throughput》（2026-05）："Overall application throughput typically lands around 1.0–1.4 Mbps even though the PHY advertises 2 Mbps"；iOS/Android 各自决定 connection interval，iPhone 不允许 7.5ms 下限 | https://argenox.com/blog/bluetooth-le-throughput-max-performance |
| S18 | Nordic DevZone Q&A（2024-08）：iOS/Android 实测，MTU 247、优化后约 800 kbps，Android 压 MIN/MAX 出现丢包低吞吐 | https://devzone.nordicsemi.com（Maximising BLE throughput on iOS vs Android） |
| S19 | NXP 官方吞吐示例工程（RT1170）：最佳 701 kbps | https://github.com/nxp-appcodehub/dm-ble-throughput-measurement-rt1170 |
| S20 | BeaconZone（2023-05）：WiFi 共存使 BLE 吞吐降约 30% | https://www.beaconzone.co.uk/blog/bluetooth-low-energy-throughput/ |
| S21 | BlueKitchen BTSTACK：ATT MTU 最小 23 字节，超 MTU 需分片、吞吐下降 | https://github.com（BTSTACK LE GATT Server Throughput） |
| S22 | SafeBreach（2024-08）：Quick Share "uses a variety of communication protocols—including Bluetooth, Wi-Fi, Wi-Fi Direct…"；Google 支持帖：关蓝牙后 Quick Share 双向检测失败 | https://www.safebreach.com/blog/windows-downdate-quick-share-vulnerability-and-more/ ；https://support.google.com/android/thread/274855228 |
| S23 | Feem 商店页：仅 local Wi-Fi / 个人热点传输（不用蓝牙） | https://play.google.com/store/apps/details?id=com.feeperfect.airsend.android |
| S24 | 学术测量：BLE legacy 广播载荷 31 字节/条（adv 与 scan response 各 31B），BT5 扩展广播可到 254B | https://www.researchgate.net（Okay Google, Where's My Tracker?）；HEAVEN 论文（polymtl） |
| S25 | freeCodeCamp BLE in Flutter 手册（2026-08）：经典蓝牙 SPP 只有 flutter_bluetooth_serial，BLE 系插件均不支持 SPP | https://www.freecodecamp.org/news/bluetooth-low-energy-in-flutter-a-handbook-for-devs |
| S26 | 本地仓库只读核对：`packages/localsend_isolates/lib/src/task/discovery/discovery.dart`（`addDevice` 注入缝，:319）、`packages/localsend_isolates/lib/model/device.dart`（Device/HttpChannel 模型）、`app/pubspec.yaml`（无任何蓝牙依赖）、`LICENSE`=Apache-2.0 | /home/z/my-project/localsend |

---

## 2. 技术事实（每条带来源）

### 2.1 BLE 用于发现的能力边界

- **F1 广播载荷很小且平台差异大**：BLE legacy 广播+scan response 各 31 字节，BT5 扩展广播理论上 254B+，但移动平台支持参差 [S24]。实践矩阵 [S10]：iOS/macOS 的 app 广播只能携带 service UUID + local name（name 约 10 字节），**manufacturer data 不可用**；Android 忽略 localName（需系统名开关）；Windows 只广播 manufacturer/service data，legacy 广播带 name/UUID 直接拒绝启动。→ 结论：跨平台"纯广播"无法承载 LocalSend 设备元数据（alias+fingerprint+IP:port），必须 **广播做轻量信标 + GATT 连接后读特征换取完整信息**。
- **F2 先例证明 24~30 字节信标够用**：Windows Nearby Sharing 的 MS-CDP BLE beacon = 30 字节 manufacturer data（24B beacon data 内含 Scenario/版本/Salt + 19B Device_Hash）[S14]；AirDrop 的 BLE 广播只放联系人哈希用于匹配，匹配成功后**改用 AWDL 上的 mDNS 广告 instance name + IP + port** [S15]。
- **F3 双角色（又广播又扫描）是插件能力问题**：flutter_blue_plus 仅 central 角色（文档原文：supports BLE Central Role only，peripheral 请看 FlutterBlePeripheral 或 bluetooth_low_energy）[S5]；`bluetooth_low_energy`（MIT）同时提供 CentralManager（Android/iOS/macOS/Windows/Linux 全绿）与 PeripheralManager（Android/iOS/macOS/Windows，Linux 缺）+ GATT server API（addService/startAdvertising/characteristicReadRequested/notifyCharacteristic/getMaximumNotifyLength）[S8]。
- **F4 前台/后台行为**：iOS 后台广播必须声明 `bluetooth-peripheral` background mode，且声明后 local name 仍被丢弃、service UUID 进 "overflow" 区——**只有同样显式按该 UUID 过滤扫描的 iOS 设备能看见，所有非 Apple 扫描方完全看不见**，广播频率也会下降 [S13][S10]。Android 广播跟随进程：后台继续、进程被杀才停；可从前台 service 运行 [S10]。
- **F5 权限**：Android 12+ 需 `BLUETOOTH_SCAN`（可带 `neverForLocation`，前提是不用扫描结果推导位置）、`BLUETOOTH_ADVERTISE`、`BLUETOOTH_CONNECT`；旧权限（BLUETOOTH/BLUETOOTH_ADMIN、位置）应 `maxSdkVersion=30` 收尾 [S12][S10]。iOS 13+ 必须有 `NSBluetoothAlwaysUsageDescription`，否则首次触碰蓝牙 app 被杀 [S10]；macOS 需蓝牙 entitlement；Windows 无 manifest 改动但 BLE 需位置权限，且**系统 Nearby Sharing 可能占用广播资源导致 ResourceInUse 失败** [S10]。
- **F6 LocalSend 社区诉求真实存在**：#850（51👍）与 #144（35👍）的反复出现的场景 = 大学/公司 WiFi 的 AP 隔离（client isolation）阻断设备互发现；#144 评论中 Bronts/phith0n 描述公司内网禁无线/禁共享，只剩几百 KB 文本传输需求 [S1][S2]。维护者 Tienisto 已表态："**Bluetooth discovery + file transmission is more reasonable**（对比 WiFi Direct）。WiFi Direct 更好但受 OS 限制（尤其 iOS）" [S1]。

### 2.2 BLE 用于传输的现实吞吐

- **F7 理论与实测**：BLE 默认 1M PHY；BT5 2M PHY 需双方 PHY Update 协商且非保证；**应用层吞吐最佳 1.0–1.4 Mbps**（Nordic 官方口径 1.4 Mbps [S16]，Argenox 2026 实测口径 1.0–1.4 Mbps [S17]）。这是嵌入式双端调优后的上限。
- **F8 手机现实**：connection interval 由 central 决定，iPhone 不允许 7.5ms 下限，Android/iOS 各按自家算法 [S17]；Nordic DevZone 实测 MTU 247 优化后 ~800 kbps，Android 激进参数反致丢包 [S18]；NXP 官方示例最佳 701 kbps [S19]。**WiFi 共存再打 ~7 折**（-30%）[S20]。ATT MTU 最小 23 字节、超限分片 [S21]。→ 手机对手机 GATT 现实吞吐按 **0.1–0.5 MB/s** 保守规划。
- **F9 大文件换算**：100 MB ≈ 3–17 分钟（0.1–0.5 MB/s）；1 GB ≈ 0.5–3 小时。且 BLE 无内建断点续传/拥塞控制（GATT notification 需自建 ACK 窗口），app 层要自己造传输协议。WiFi Direct/热点/LAN 的现实吞吐是它的 40–1000 倍量级。

### 2.3 经典蓝牙（BR/EDR、RFCOMM/SPP）在 Flutter 的现状

- **F10** 唯一常用库 flutter_bluetooth_serial v0.4.0 **5 年未更新、仅 Android**（README 原文 "For now there is only Android support"，最多 7 连接，RFCOMM/SPP）[S11]；fluttergems 维护状态标注 Poor [S11]；freeCodeCamp（2026-08）确认 BLE 系插件均不处理 SPP，经典蓝牙只剩这个库 [S25]。
- **F11** iOS 对 app **不开放经典蓝牙串口/OBEX 文件传输 API**（CoreBluetooth 仅 LE；#144 评论确认 iOS 无系统级蓝牙文件传输，OBEX 只存在于越狱插件史）[S2][S5]。→ 经典蓝牙跨平台路线（iOS+桌面）在 API 与插件两个层面同时断裂。

### 2.4 插件生态与许可（关键新变量）

- **F12 flutter_blue_plus 2.x 许可已质变**：2.0.0 起 switching 到 "FlutterBluePlus License"（非营利免费、营利需商业授权）；2.1.0 起 15 人以上公司需商业授权，后续加 Corporate/Global tier；**2.3.5 起构建期向作者服务器发 license ping（含 package name & app name）**；pub.dev 许可字段显示 unknown（非 OSI）[S5][S6]。对一个 Apache-2.0 的开源项目（本仓库 LICENSE=[S26]），这是**采纳阻断项**（downstream 分发者合规风险 + 构建遥测）。最后 BSD-3-Clause 版本 = 1.36.8（2025-09-17）[S7]，但其仅 central 角色，做不了广播。
- **F13 可行的开源替代**：`bluetooth_low_energy` 6.2.1（MIT，publisher=zeekr.dev 即极氪汽车验证发布者，12k 周下载，双角色+全平台 central）[S8]；`flutter_ble_peripheral` 3.1.0（BSD-3，4 平台广播+GATT server，文档质量高）[S10]；`flutter_reactive_ble` 5.6.0（BSD-3，Signify/meethue 维护，但仅 Android+iOS、central-only）[S9]。
- **F14 LocalSend 当前零蓝牙依赖**（app 与 isolates 的 pubspec 均无 bluetooth 相关条目）[S26]。

### 2.5 平台权限/能力速查矩阵（汇总自 S5/S8/S10/S12/S13）

| 能力 | Android | iOS | macOS | Windows | Linux |
|------|---------|-----|-------|---------|-------|
| 扫描（central） | ✅ API 21+，12+ 需 SCAN 权限 | ✅ 需 Usage Description | ✅ 需 entitlement | ✅ 需位置权限 | ✅（BlueZ） |
| 广播（peripheral）+ GATT server | ✅（后台=进程存活期） | ✅（前台；后台=overflow，非 Apple 扫描不可见） | ✅（app 运行期） | ✅（仅 mfg/service data；Nearby Sharing 抢占风险） | ❌（插件无 peripheral API） |
| 广播可携带内容 | service data/mfg data（不含 name 需开关） | 仅 service UUID + name(~10B) | 同 iOS | 仅 mfg/service data | — |
| 经典蓝牙 SPP（第三方 app） | ✅（唯一可用插件已停更） | ❌ 无公开 API | ❌ | ❌（仅系统 MS-CDP 特权实现） | 部分（无统一 Flutter 通路） |

注：iOS 后台广播行为引自 Apple 官方文档 [S13]；Windows 广播限制与 Nearby Sharing 冲突引自 flutter_ble_peripheral README [S10]；Linux 缺口引自 bluetooth_low_energy API 矩阵 [S8]。

---

## 3. 先例分析：它们用蓝牙做什么

| 产品 | 蓝牙角色 | 传输用什么 | 来源 |
|------|---------|-----------|------|
| Apple AirDrop | BLE **只做发现/匹配**（广播联系人哈希）；匹配后接收方在 AWDL 上用 mDNS 广告 **instance name + AWDL IP + port** | HTTPS over AWDL（点对点 WiFi），**不经蓝牙** | [S15] |
| Windows Nearby Sharing（MS-CDP） | BLE **只做发现**（30B 广播信标，含 salt+19B 设备哈希）+ 可作为传输通道之一 | 传输层官方枚举 BLE / Bluetooth / LAN / WiFi Direct，按可用性选择 | [S14] |
| Google Quick Share | 蓝牙（含 BLE）参与发现；社区证据：关蓝牙后设备互相检测失败 | "variety of communication protocols—including Bluetooth, Wi-Fi, Wi-Fi Direct…"（多介质，BLE 非主力载荷通道） | [S22] |
| Feem | **不用蓝牙** | 仅本地 WiFi / 个人热点 | [S23] |
| PairDrop（Tienisto 在 #850 提及并否决） | 不用 | WebRTC，需要第三方信令服务器，违背 LocalSend 离线原则 | [S1] |
| Berty（#144 评论提及） | BLE mesh 传消息（小文本可行性的旁证） | BLE | [S2] |

**共同模式**：头部产品一致采用 "**蓝牙（BLE）只负责发现/引导，载荷传输走 IP 通道（AWDL/LAN/WiFi Direct/热点）**"；没有任何主流产品用 BLE 传大文件。MS-CDP 甚至把 BLE 列为可用传输之一但只在更低速场景兜底。LocalSend 与该模式天然同构：已有 HTTP v2 传输 + multicast 发现，BLE 恰好补的是"发现层被 AP 隔离打掉"的洞 [S1][S2][S26]。

---

## 4. 切合度结论（核心）

### 4.1 蓝牙辅助发现（BLE 信标 + GATT 交换 IP:port → 引导现有 HTTP 连接）：**高**

论据：
1. **命中真实痛点**：AP 隔离/无 multicast 网络是 fork 已花大量精力缓解的场景（smart scan/诊断），BLE 发现是唯一不依赖 WiFi 基础设施补救手段；上游 #850 51👍/#144 35👍，维护者本人认可"BT 发现+传输比 WiFi Direct 更现实（iOS 限制）" [S1][S2]。
2. **先例背书**：AirDrop / MS-CDP / Quick Share 全部用 BLE 做发现引导，载荷走 IP；LocalSend 已有完整 HTTP 通道，只需把"设备进入 Device store"这一步换一条入口 [S14][S15][S22]。
3. **协议红线零冲突**：BLE 发现的设备最终仍走官方 v2 register/upload HTTP 流程，v2 协议字节不动；与 fork 双分支纪律一致 [S26]。
4. **载荷可行**：信标只需 ~24 字节（MS-CDP 同款：版本/场景 + port + fingerprint 哈希前缀）[S14]；完整元数据走 GATT 读特征（几百字节 JSON，毫秒级）[S8][S10]。
5. **依赖可行**：`bluetooth_low_energy`（MIT，双角色，5 平台扫描/4 平台广播）一个包即可覆盖 Android/iOS/macOS/Windows 主战场 [S8]。

边界（不影响评级但必须写明）：
- Linux 桌面只能扫描不能广播（无 peripheral API）→ Linux 设备可主动发现别人，但别人发现不了它 [S8]。
- iOS 后台广播进 overflow 区、非 Apple 扫描方不可见 [S13]——但 LocalSend 接收本来就要求 app 前台打开，此限制与产品模型正交。
- 广播内容对周围所有人可见 → fingerprint 不能明文，用 salt+hash（MS-CDP 同款方案）[S14]。
- Windows 上系统 Nearby Sharing 可能占用广播资源（ResourceInUse），需检测并引导用户 [S10]。

### 4.2 蓝牙传输文件

- **小文本/剪贴板（≤ ~64 KB）：中**。
  论据（正向）：0.1–0.5 MB/s 下 64 KB = 0.1–0.5 秒~数秒，体验可接受；是"完全无 WiFi"场景的唯一 app 内通路；#144 评论者明确表示多数诉求是传文本 [S2]。
  论据（负向）：需要自建 GATT 分帧/ACK/重试协议；与现有 send provider/进度 UI/session 模型并行再造一条小传输栈，收益/成本比一般；且系统级"分享→蓝牙"在 Android/macOS 已存在（#144 反方评论的观点 [S2]），app 内价值主要剩 iOS 出向与文本快捷通道。建议仅作为阶段 2 的 fallback 实验，且默认关闭。
- **大文件（照片/视频/APK）：低**。
  论据：现实吞吐 0.1–0.5 MB/s（§2.2 F8），100 MB 数分钟到十几分钟、1 GB 小时级；无内建断线续传，全部 app 层自造；WiFi 共存 -30% [S20]；**所有先例都不这么做**（§3）；LocalSend 的核心价值主张是"快"（fork 还在优化批量 15k 文件的吞吐），用 BLE 传大文件与产品定位相悖。阶段 3 仅做"实测+给结论"，默认不做产品化。

### 4.3 经典蓝牙（BR/EDR RFCOMM/SPP）：**低（不推荐）**

论据：唯一插件停更 5 年 + 仅 Android（F10）；iOS 无公开 API（F11）；桌面 Linux/Windows 无统一通路。跨平台断裂使其在本项目不可行。MS-CDP 把 "Bluetooth" 列为传输介质是 OS 级特权实现，第三方 app 复刻不了 [S14]。

---

## 5. 推荐集成设计（结论支持"做发现引导"）

### 5.1 最小可行设计（阶段 1：BLE 辅助发现引导）

**模块边界（全部在 app 侧主 isolate，不进 localsend_isolates/Rust——platform channel 只能在 root isolate 用，且协议红线在 Rust 侧）**：

```
app/lib/provider/network/ble/
  ble_discovery.dart        // BleDiscoveryService：编排广播+扫描+GATT 握手
  ble_transport.dart        // 抽象接口：startAdvertising(payload)/scan()/readDeviceInfo()
                            //   + const BleTransport noop 实现（feature flag 关闭时）
  ble_codec.dart            // 信标 24B 编解码 + GATT JSON（pure dart，重点单测对象）
  ble_discovery_provider.dart // refena provider，feature flag 门控
```

- **默认 noop + feature flag**：settings 新增 `ls_ble_discovery_enabled`（默认 false，复刻 maxInterfaces 的 settings_state/persistence/provider/settings_tab 四件套模式，见 worklog Task 30-b 先例）。flag 关 = 零蓝牙调用、零权限请求、零行为差异（pubspec 依赖虽在但 Android/iOS 权限运行时才请求 [S12][S10]）。
- **与现有 discovery 的接缝（零侵入）**：BLE GATT 读到对端 `{alias, fingerprint, ip, port, https, deviceModel, deviceType, download, version}` → 构造 `Device(channels: [HttpChannel(host: ip, port: port, https: https)])` → `dispatchTakeResult(IsolateDiscoveryAddDeviceAction(...))` → Rust store 合并 → 现有 `StartDiscoveryListener` 流 → `RegisterDeviceAction` 进 UI。这正是 HTTP register 路径已用的外部注入缝（`discovery.dart` 的 `addDevice`，[S26] 文件 :319；app 侧 `nearby_devices_provider.dart` 的 doc comment 亦确认该语义）。发送链路、进度 UI、会话模型**零改动**。
  数据流示意（均为现有代码路径，仅入口新增）：
  ```
  [BLE adv 扫描命中] → [GATT connect + read 特征]
        → ble_codec.decode(json) → Device(channels:[HttpChannel])
        → IsolateDiscoveryAddDeviceAction   // 复用：HTTP register 同款注入缝
        → Rust discovery store 合并（fingerprint 去重、channel 列表追加）
        → StartDiscoveryListener stream → RegisterDeviceAction
        → nearbyDevicesState.devices → 现有设备列表 UI
  发起发送时：send_provider 照常拨 HttpChannel（v2 register/upload），协议字节零改动。
  ```
  注意点：Rust store 以 `ip != null` 为入库前提（`addDevice` 对 `ip == null` 直接跳过，[S26] :322），故 BLE 引导必须在对端通告其本机 IP（同一 WiFi 但 AP 隔离时 IP 仍可达——隔离阻断的是 multicast/广播，unicast 视 AP 策略而定；若 unicast 也被隔离，阶段 1 诚实地显示"发现但不可达"，与现有 favorites 手动 IP 行为一致）。
- **信标/握手设计**（跨平台约束下 [S10]）：
  - Android/Windows：manufacturer data = `[protoVer(1)|port(2)|fpHash(8)|salt(4)|reserved]`（≤24B，MS-CDP 同量级 [S14]）。
  - iOS/macOS：广播仅 service UUID（128-bit 专属 UUID）+ local name（短前缀）；扫描端按 service UUID 过滤。
  - 连接后 GATT：一个 read-only 特征返回完整 JSON（UTF-8，<512B）；可选 write 特征做"请求注册"。
  - 双端同时开（前台）时：A 广播+扫描，B 广播+扫描，互发现后各读对方 GATT → 双方 Device store 都有对方。
- **单测策略**（本环境门禁 = analyze+test）：`ble_codec`（编解码/越界/clamp）+ `BleDiscoveryService` 用 fake transport（注入假扫描结果与假 GATT payload）断言：①产出 Device 结构正确 ②fingerprint 去重/合并语义与 RegisterDeviceAction 一致 ③flag 关时零 dispatch ④信标 payload ≤ 31B。复用 `_RecordingConnector`/`_FakePersistence`/mocks 先例（EXPERIENCE.md §2）。

### 5.2 依赖引入建议

- **不引入 flutter_blue_plus**（任何 2.x）：许可质变 + 构建期 license ping + central-only 三重否决 [S5][S6]。1.36.8 虽 BSD 但无广播能力，不解决问题 [S7]。
- **引入 `bluetooth_low_energy: ^6.2.1`**（MIT [S8]）：一个包覆盖双角色 + 4.5 平台，Apache-2.0 项目无合规障碍。代价：新增一个带原生代码的依赖（体积影响可忽略）；风险：6.x 主版本迭代较快（7.0.0-dev 预发中）、非 chipweinberger 级社区规模，但 publisher 为 zeekr.dev（车规产线在用）+ MIT 兜底可 fork。
- 备选组合：`flutter_ble_peripheral`（广播/GATT server）+ `flutter_ble_central`（扫描）[S10]——文档更细但两个依赖、API 面
更窄，列为 plan B。
- **平台清单改动**（引入后）：
  - AndroidManifest：`BLUETOOTH_SCAN`（`neverForLocation`）、`BLUETOOTH_ADVERTISE`、`BLUETOOTH_CONNECT`；`BLUETOOTH`/`BLUETOOTH_ADMIN` 加 `maxSdkVersion="30"` [S12]。
  - iOS Info.plist：`NSBluetoothAlwaysUsageDescription` [S10]；**不加** background modes（阶段 1 前台即可，回避审核与后台杀广告问题 [S13]）。
  - macOS：`com.apple.security.device.bluetooth` entitlement（Debug+Release 两份）[S10]。
  - Windows：无 manifest 改动；处理 ResourceInUse（检测 Nearby Sharing 占用并引导）[S10]。

### 5.3 分阶段路线

1. **阶段 1（发现引导）**：如上 MVP。验收 = 真机上 AP 隔离网络中 Android↔iOS 互发现并完成一次 HTTP 发送；门禁 = analyze/test/format 四件套。
2. **阶段 2（小载荷，默认关）**：GATT write/notify 通道传文本/URL（≤64KB），仅当"无可用 IP 通道"时 UI 提示启用；自建 分帧+ACK；进度 UI 复用 session 模型的最小子集。
3. **阶段 3（大文件评估，默认不做产品化）**：真机实测手机对手机 GATT 吞吐矩阵（iOS↔iOS / iOS↔Android / Android↔Android / 桌面），产出数据后决策——预期结论是"仅提示蓝牙慢速模式"或放弃（§4.2 论据）。

### 5.4 明确不做的事 + 原因

- ❌ 经典蓝牙（RFCOMM/SPP/OBEX）：插件停更 + Android-only + iOS 无 API（F10/F11）。
- ❌ BLE 大文件默认路径：吞吐/续传/先例三重否决（§4.2）。
- ❌ iOS 后台常驻 BLE 发现：系统 overflow 限制 + 审核风险 + 与"接收需前台"的产品模型冲突 [S13]。
- ❌ 任何 v2 协议字节改动：两分支纪律（EXPERIENCE.md §2 红线）。
- ❌ WiFi Direct / AWDL 类点对点 WiFi：上游 #189（64👍）仍未解、iOS 阻塞（#2591 closed、维护者结论 [S1][S3]）；若未来做，应与 BLE 发现解耦独立立项。
- ❌ WebRTC/信令服务器方案（PairDrop 式）：违背无服务器原则（维护者原话 [S1]）。
- ❌ 上游 PR #3250 式 CompanionDeviceManager 方案照搬：Android-only 且该 PR 已被维护者以质量原因关闭 [S4]（CDM 可作为日后 Android 侧"靠近自动唤醒"增强，单独评估）。

---

## 6. 风险与限制（诚实边界）

1. **本沙箱无蓝牙硬件、无真机、无模拟器蓝牙**（bluetooth_low_energy README 明言 BLE 在模拟器上不工作 [S8]）：本报告全部为文献+代码静态调研；阶段 1 实现后**只能以 analyze+test+format 门禁验证**，蓝牙行为必须真机矩阵（Android 8/12+/15、iOS 15+、Win10/11、macOS、Linux）实测，结论才有工程效力。
2. 平台行为差异大且随 OS 版本漂移（iOS overflow 语义、Windows Nearby Sharing 抢占、厂商 Android 栈差异）[S10][S13]；设计已按"最差平台约束"收敛，但仍需实测背书。
3. 插件生态在变：flutter_blue_plus 许可事件（F12）说明单包风险真实存在；MIT/BSD 依赖可随时 vendor/fork 自保，但需要持续跟踪 `bluetooth_low_energy` 7.x 的破坏性变更。
4. 隐私与安全需专门评审：广播可见性（信标 salt+hash 方案参考 MS-CDP [S14]）、GATT 无配对时的匿名写入、以及"扫描 = 位置推导"的 Play 政策边界（neverForLocation 声明的正当性 [S12]）。
5. 功耗：连续扫描耗电；阶段 1 应只在 send/receive 页面活跃期间扫描（duty-cycle + 页面生命周期绑定），不做常驻后台扫描。

---

## 附：一句话结论

**做"BLE 信标 + GATT 握手 → 引导现有 HTTP v2"的发现辅助（切合度：高，先例同构、痛点真实、协议零冲突）；不做蓝牙大文件传输（低）；小文本 BLE 通道作为可选阶段 2 实验（中）；经典蓝牙彻底排除（低）。依赖选 `bluetooth_low_energy`（MIT），feature flag 默认关，模块全部落在 app 侧主 isolate，经 `IsolateDiscoveryAddDeviceAction` 现有注入缝进入设备流。**
