
---

## 三、挑刺清单（按严重度排序，行号级证据）

| 级别 | 问题 | 位置/证据 | 一句话裁决 |
|---|---|---|---|
| 🔴 高 | 把**现存缺陷**误分类为"改一半风险"：whitelist/blacklist/multicastGroup/discoveryTimeout 变更后，settingsProvider.onChanged（settings_provider.dart:21-40）→ IsolateSyncSettingsAction → 子 isolate syncProvider 更新，**但运行中的 discovery 不重启、新配置不生效**。 Devil's advocate 对此穷尽了 6 条反例路径（serverProvider.ensureRunning、全部 restartServer 调用方、IsolateSyncServerStateAction、子 isolate 流监听、全仓 dispatch 点、NetworkInterfacesPage）均告失败，缺陷确认为真 | discovery.dart:59-79（while 循环每轮开头才读 syncState，:53-57 流监听只响应 serverRunning）；actions_sync.dart:51-78/:113-145 只同步不重启；全仓 IsolateDiscoveryRestartAction dispatch 恰 2 处 | **最强源码内证据是设计意图与实现的断裂**：discovery.dart:124、discovery_isolate.dart:40、actions.dart:169 三处 doc 注释都写明 restart 意图包含 "network settings changed"——注释说要做的事，代码没有做。这不是未来风险，是当下可复现的配置失效 bug |
| 🔴 高 | 机制 4"全盘失联"结论过强，漏掉 UI 兜底 | send_tab.dart:331（`ips.length <= maxInterfaces` 条件）+ :349-354（子网选择弹窗，`StartLegacySubnetScan(subnets: [ip])`，一次只扫一个网段） | 结论应改为"自动发现系统性遗漏热点网段 + 补救入口（子网弹窗）对普通用户不可发现 + 弹窗单网段扫描"。原表述会被维护者用 :349 一行反驳，削弱整个机制 4 |
| 🟠 中 | 降级 2 不知道超时已是用户可配置项 | settings_tab.dart:466-478；constants.dart:19；discovery.dart:78 | "放宽到 1500-2000ms"今天就能在高级设置里手动做（且同样受新缺陷 1 拖累，改后需重启 discovery 才生效）；代码改动的卖点是自适应 |
| 🟠 中 | E.2 漏第 13 处运行时陷阱 + "唯一已就绪"措辞不严谨 | nearby_devices_provider.dart:87 assert；discovery.dart:216-222 的 skip-and-log 降级 | 陷阱清单若用于真实 PR，#13 会在第一次 debug 运行暴露 |
| 🟠 中 | **7 处行号错标**：scan_facade.dart:22（实为 15/21）、api/discovery.rs:141（实为 144）、favorite_device.dart:16（实为 12）、device.dart:56（实为 58）、discovery.dart:30（实为 28）、event_backpressure.rs:29（实为 27）、init.dart:191（实为 190） | 各对应文件 | 单看每处都是 ±1~7 行小事，但报告的公信力人设建立在行号级精确上，7/79 的错标率说明最后没做机械校对。已核实与版本漂移无关（评审基准与报告基线为同一 commit，且 2026-08-24 后发现链路文件无位移性改动）——就是纯校对遗漏 |
| 🟠 中 | "日志只有一条 warn"量级写反 | multicast/mod.rs:352-360：每错一条 warn + 放弃一条 error | 原报告低估日志量；实操后果是日志易查而非难查。错误方向对，量级写反 |
| 🟡 低 | 路径书写歧义（api/discovery.rs 不在 core） | packages/localsend_isolates/rust/src/api/discovery.rs | 跨 crate 调用链报告必须写全路径 |
| 🟡 低 | [citation:N] 不可解析、出现 "citation:4-旧" | C.1、参考出处 | 违背报告自己"逐条给证据"的风格 |
| 🟡 低 | flutter_blue_plus 的 Web 支持无出处 | A.6 | 按报告标准应标"待核实" |
| 🟡 低 | 组播测试 self-skip 的 CI 盲区未提 | tests/discovery.rs:7-9 | "必跑"清单应注明环境要求，否则是假安全网 |

**机制定级说明（回应"机制 3 与机制 4 双重标准"质疑）**：机制 3（TTL=1）判"正确设计"、机制 4（`.1` 排序）判"代码缺陷"，区分依据是可辩护性——TTL=1 有协议层的明确理由（发现仅限本地链路，调大反而把发现流量泄到邻居网络），而 `.1` 排最后没有类似的设计文档支撑，且与热点网关 IP 的普遍形态直接冲突、没有例外分支。两者同为"合理默认值在特定拓扑下失效"，但一个是显式设计决策，一个是启发式盲区。**补充事实**：`.1` 排序是维护者 2023-01（commit 338f9a725）亲手实现且被 4 个测试用例钉死的刻意行为——修复它属于"heuristic gap 提案"而非 bug fix，这一区分对上游策略有直接影响（见拓展三）。

**挑刺之外的公道话**：(1) "先证伪"自查意识（B.1 先推翻"单频"前提）；(2) E.2 编译期/运行时风险二分法；(3) AOSP 桥接软 AP 与路由器 VLAN 的区分；(4) Part D "不改代码"的克制结论；(5) 机制 4 把 `.1` 规则与热点网关 IP 特征关联是全报告最有洞察力的发现。这份报告的问题不是能力问题，是**收尾校对和最后一公里调研**问题。

---

## 四、报告遗漏的现存缺陷与盲区（评审新增，全部经反例攻击确认）

### 新缺陷 1：设置变更后 discovery 不应用新配置（🔴 建议列入 P0，全案最佳首发修复）
见挑刺清单第 1 条。修复注意：`IsolateDiscoveryRestartAction` 走 `sendToIsolate(syncState: null)`（actions.dart:178-185），子 isolate 用的是已同步的 syncProvider 状态；同一 `SendToIsolateData` 通道内消息 FIFO 有序，把"先 sync 后 restart"做成复合 action（或在 onChanged 内顺序 dispatch 两个 action）即可被通道有序性天然覆盖，竞态风险低于初稿评审的担忧——但仍建议 PR 中显式注释该依赖。

### 新缺陷 2：事件通道满时静默丢弃已确认设备（🟠 并入 Part C 论证）
`DiscoveryState::found()` 用 `try_send` 保扫描不死锁（discovery/mod.rs:193-207，注释自认 "Dropping an event only costs a refresh"），代价是通道满（16，api/discovery.rs:192）时 Discovered/Updated 事件被 drop，仅 debug 日志。UI 侧无任何 `devices()` 轮询兜底，被丢事件导致的"缺人"要等下次重新确认才恢复。这同时是降级 1 的第二个论据和机制 2 症状（"设备时有时无"）的另一种成因。

### 新盲区 3：README 已写明的三类经典失效被四个机制跳过
官方 Troubleshooting 除 AP 隔离外还列了：**Windows 防火墙/专用网络**、**VPN**（"allow local/LAN traffic or temporarily disable"）、**iOS/macOS 本地网络权限**。作为面向用户实操的 B.3 排查序列，这三条必须占位。**补充（评审团协议专家提供，两份报告共同的最大盲区）**：全仓 grep 确认 LocalSend **没有申请 `CHANGE_WIFI_MULTICAST_STATE` 权限、没有一行 MulticastLock 代码**——Android 驱动默认过滤组播包，App 能否收到 announce 依赖 AP 的组播转单播或其他应用恰好持锁。multicast/mod.rs:26-28 选 224.0.0.0/24 组地址的注释说明 Rust 侧作者踩过此坑，但 App 层从未申请锁。这解释了"为什么多数设备仍能被发现、换个路由器就好了"的用户传闻，也解释了"设备时有时无"的一个独立成因。另见 init.dart:212-220：**Android 17+ 已有本地网络权限申请流**（"Android 17+ blocks multicast discovery and LAN connections until this permission is granted"），拒绝时仅 warning + 弹窗，无重试引导。

---

## 五、拓展（本章为"建议稿"属性：基于评审发现的工程提案，非逐条核查结论；标注 📌 的为源码锚点，标注 ❓ 的为待实测/待核实项）

### 拓展一：补缺失的失效机制（并入 Part B/C）

**机制 5（⭐⭐）：系统权限类失效——iOS/macOS 本地网络权限 + Android 17+ 本地网络权限**
iOS 侧：bind + join 组播组会成功（拦截在包转发层而非 socket API 层），**接收侧静默**（包被系统丢弃，recv 无报错 → 10 连错永不触发），与机制 1/2 症状高度相似但根因在授权。**发送侧不静默**❓：主流 iOS 版本对被拒状态下的本地网络 UDP send 返回 EPERM，落在 multicast/mod.rs:200-202 的 warn（"Could not send multicast message"）——这是比"未弹权限框"更硬的排查指纹（每次 announce 3×接口数条），建议实机复核后写入 B.3。注意：LocalSend iOS **已持有** multicast entitlement 与 NSLocalNetworkUsageDescription（entitlements 配置齐全），所以这是"用户拒绝"场景而非配置缺失。Android 侧：init.dart:212-220 已实现 Android 17+ 权限申请，但拒绝后仅弹窗一次，无重试与状态提示。

**机制 6（⭐⭐）：VPN/虚拟网卡的三重叠加**
(a) VPN 网卡 IP 参与排序且通常不以 `.1` 结尾、得分高于热点网段，加剧机制 4；📌 `local_interfaces()` 只滤 loopback，无任何按名称/类型过滤（interface.rs:101-174），tun/ppp/utun 全部通过，组播 socket 在 tun 上照常绑定——启动日志 `Bound UDP multicast socket (interface: utun3 ...)`（socket.rs:42-44）可直接自查。(b) VPN 强制隧道丢弃局域网流量（README 明列）。(c) 发送出口已被 `set_multicast_if_v4` 钉死在 tun 上（socket.rs:111），行为取决于 tun 驱动/VPN 策略而非"系统路由"。**两个被漏掉的连带后果**：announce 载荷（alias/fingerprint/port）会泄漏进 VPN 隧道（隐私）；`local_interface_addresses` 含 tun 子网 → 兜底 `/24` 扫描会对 VPN 网段发 255 个探测。**现成用户级缓解**：设置页网络黑名单本可排除 tun 接口（InterfaceFilter 已支持），报告未提。修复建议中的"按前缀默认排除虚拟网卡"须注意接口命名跨平台差异（utun*/wg*/tailscale0/tap*/ppp*），黑名单必须可配置且排除时留日志，否则制造新的静默死亡。

**机制 7（⭐⭐，由原评审机制 7 升级合并）：Android 侧组播接收抑制——MulticastLock 缺失 + Doze + OEM 查杀**
修正两处初稿错误：① "Doze 冻结 NSD"不成立——系统 NSD 守护进程豁免于 Doze 的 per-UID 防火墙，被冻结的是**应用自己的组播 socket**；② Doze 需"静止+息屏+电池"才触发，交互式传输不命中。升级依据见新盲区 3（MulticastLock 缺失是更普遍、更日常的抑制源）；前台服务（AndroidManifest:91-96，dataSync 类型）仅覆盖接收进度保活，且 FGS 本身不豁免 Doze 网络挂起。

**机制 2 归因修正（不降级，改因果链）**：RF 干扰造成的是丢包，recv 只是等不到数据、**不产生 socket 错误**——"2.4G 干扰重所以先抖死"的因果不严谨。10 连错的真实触发是接口状态翻转/驱动重置/系统挂起回收。且存在**比原报告更静默的路径**：接口短暂 down/up 后内核已清除组播成员关系，socket 无任何报错、recv 永久阻塞——连那 10 条 warn 都没有。可观测性候选：`multicast_loop` 已开启且 own message 按 fingerprint 自过滤（socket.rs:113-115、mod.rs:376-378），可周期性发一条期待回环的自检作"存活探针"。

**机制 8（观察项）：发现协议无 mDNS/NSD 成分**
v2 发现 = UDP 组播 announce（224.0.0.167）+ HTTP register，全程无 mDNS。补两个例外角防反例：① 部分 AP 隔离实现是"拦客户端间单播、放行客户端间组播"（常见于 guest 网络），此时 mDNS 反而能工作而 LocalSend 死在 HTTP register 步骤；② Doze 下系统 NSD 比应用自持 socket 抗造。但结论不变：LocalSend 设备不做 DNS-SD 服务广告，NsdManager 无现成服务可浏览，"子网扫描是唯一普适兜底"成立。

### 拓展二：安全维度（并入 Part A；本节经安全审查员逐锚点复核后修订）

1. **"指纹短哈希"不等于匿名，且轮换的范围比初稿说的更大**。引用勘误：AirDrop 联系人哈希被字典攻击的历史是 2019-05 负责任披露 + **PrivateDrop（USENIX Security '21）** + AirCollect（ACM WiSec '21），初稿误写为 "USENIX Sec'19"。📌 两个改变论证范围的锚点：**当前协议已在明文 UDP 组播里广播完整稳定指纹**（model/discovery.rs:126-129，HTTPS 模式即证书 SHA-256）；**证书有效期 1975-4096、注释明言不轮换**（crypto/cert.rs:24-30）。因此 BLE-only 载荷轮换对 LAN 攻击者完全无效（指纹照听），轮换要做就要做在发现层整体——而 register 应答字段固定（dto_v2.rs），没有轮换 ID 的位置，"轮换 UUID ↔ 设备"的匹配链会断裂，需要带外配对（PIN/二维码）或协议扩展。原报告 L1 "不动安全模型"的前提与"标识符轮换"的要求**互相矛盾**，这是比"哈希可链接"更深的设计问题。
2. **L1 的安全边界有现成代码锚点，但"零改动"要按模式限定**。📌 probe 用不 pin 的 client（discovery/mod.rs:142-152）→ HTTPS 应答指纹取自证书（:168-176）→ answer_announcement 按公告指纹预置 pinning（:519-527，方向描述正确：应答方作为 TLS client 验证公告方证书）。**TOFU 判定（初稿漏做）**：公告是无认证明文 UDP，预期指纹可被影响，但 pinning 证明的是私钥持有——伪造公告冒充**他人**只会握手失败，声称**自己**则以真实身份入 store，无第三方冒充与 MITM 提升；残留面是自有身份注入 + 盲 probe。**注意 :521 的 HTTP 分支完全不 pin**，:545 的注释 "The pinned certificate identifies the peer" 在 HTTP 分支不成立。
3. **HTTP 模式的真实攻击面（初稿全称命题错误，修订）**：初稿称"probe 结果进 store 前都经过 HTTP TLS"——**仅 HTTPS 模式成立**。HTTP 模式（用户可关加密）下：probe 指纹取自 body 声称（discovery/mod.rs:175）、服务端 register 无条件放行（server/v2.rs:163-166 `None => true`）、传输无 pinning 可言。**假设备能进 store**，且更重的两条：服务端 /register 注入路径比 BLE 更直接（事件经 add_device 入 store）；**同指纹异 host 的确认会追加通道并整体替换设备元数据**（store.rs:206-227）——攻击者从受害者自己的明文公告学到指纹后，可把指向攻击者 IP 的通道挂到受害者设备条目上，`get_ranked_channels` 可能选中它，HTTP 传输即明文截获。BLE 的边际增量不是"新攻击"（组播伪造今天就能做）而是**无用户操作的后台触发**。另：answer_announcement 的 `tokio::spawn` 无并发上限（discovery/mod.rs:488），与 scan_subnet 的 SCAN_CONCURRENCY+ScanGuard 形成反差，BLE 引入后限频应统一覆盖两条路径。
4. **BLE 平台安全模型（初稿缺失）**：Android 12+ 需运行时 BLUETOOTH_SCAN/ADVERTISE/CONNECT（建议 neverForLocation），≤11 扫描需定位权限（隐私退步 + 商店审核项）；BLE 广播 MAC 随机化意味着匹配只能靠载荷（反向强化第 1 点的轮换讨论）；L2 GATT 凭据交换需 LE 配对，Legacy "Just Works" 无 MITM 防护——L2 引导必须 LE Secure Connections 或带外校验。
5. **回归锚点**：v2_tls_pinning.rs（doc 原文 "authenticates the peer certificate during the TLS handshake, i.e. before any request data is written"）验证"指纹不匹配时请求数据永不抵达对端"，作为 L1/L2 硬门槛成立。注意该测试 `#![cfg(feature = "http")]` 且只覆盖 HTTPS 路径。
