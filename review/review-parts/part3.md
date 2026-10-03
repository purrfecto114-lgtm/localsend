
---

## 三、挑刺清单（按严重度排序）

| 级别 | 问题 | 位置/证据 | 一句话裁决 |
|---|---|---|---|
| 🔴 高 | 把**现存缺陷**误分类为"改一半风险"。whitelist/blacklist/multicastGroup/discoveryTimeout 变更后，`settingsProvider.onChanged`（settings_provider.dart:21-40）→ `IsolateSyncSettingsAction` → 子 isolate 的 syncProvider 确实更新了，**但运行中的 discovery 不会重启**：`_runListener` 的 while 循环只在 listen 流结束时才用新 syncState 重新 `startDiscovery`（discovery.dart:59-79），而 restartListener 全仓库只有 iOS resumed 和设置页保存两个触发点。用户改了网络过滤，Rust 侧 InterfaceFilter 纹丝不动，直到重启 App 或改端口 | settings_provider.dart:21-40；discovery.dart:59-79、:110-120；actions_sync.dart:51-78 | 报告 D-1 只说"必须确认同步链路真的触发了"——这不是风险提示，这是一个**当下就存在的、可复现的配置失效 bug**，且与机制 1 修复属于同一张 PR 的射程 |
| 🔴 高 | 机制 4"全盘失联"结论过强，漏掉 UI 兜底 | send_tab.dart:331-347：`ips.length > maxInterfaces` 时刷新按钮变成子网选择弹窗，走 `StartLegacySubnetScan(subnets: [ip])` | 结论应改为"自动发现系统性遗漏 + 手动补救入口不可发现 + 弹窗一次只能扫一个网段"；原表述会被维护者一眼反驳，削弱整个机制 4 的说服力 |
| 🟠 中 | 降级 2 不知道超时已是用户可配置项 | settings_tab.dart:466-478；constants.dart:19；discovery.dart:78 | "放宽到 1500-2000ms"今天就能在高级设置里手动做到；代码改动的真正卖点是自适应 |
| 🟠 中 | E.2 漏第 13 处运行时陷阱 + "唯一已就绪"过度声明 | nearby_devices_provider.dart:87 的 assert；discovery.dart:216-222 的 null 降级 | 陷阱清单若用于真实 PR，第 13 处会在第一次 debug 运行就暴露，清单缺它就是不完整 |
| 🟠 中 | 行号错标 6 处：scan_facade.dart:22（实为 15/21）、api/discovery.rs:141（实为 144）、favorite_device.dart:16（实为 12）、device.dart:56（实为 58）、discovery.dart:30（实为 28）、event_backpressure.rs:29（实为 27）、init.dart:191（实为 190） | 各对应文件 | 单看每一处都是 ±1~7 行的小事，但报告的全部公信力建立在"行号级精确"上，6/60+ 的错标率说明最后没有做一轮机械校对 |
| 🟠 中 | "日志只有一条 warn"与源码不符 | multicast/mod.rs:352-360：每错一条 warn + 放弃时一条 error | 排查指引若让用户"找那条 warn"，会找不到 |
| 🟡 低 | 路径书写歧义（api/discovery.rs 不在 core） | packages/localsend_isolates/rust/src/api/discovery.rs | 跨 crate 调用链报告必须写全路径 |
| 🟡 低 | [citation:N] 不可解析、出现 "citation:4-旧" | C.1、参考出处 | 外部数据全部不可追溯，违背报告自己"逐条给证据"的风格 |
| 🟡 低 | flutter_blue_plus 的 Web 支持无出处 | A.6 | 按报告标准应标"待核实" |
| 🟡 低 | 组播测试会 self-skip 的盲区未提 | tests/discovery.rs:6-8 | "必跑"清单应注明 CI 环境要求，否则是假安全网 |

**挑刺之外的公道话**：以下四点是报告做对了且大多数同类报告做不对的——(1) "先证伪"自查意识（B.1 先推翻"单频"前提再谈异常）；(2) E.2 的编译期/运行时风险二分法；(3) 对 AOSP 桥接软 AP 与路由器 VLAN 的区分（机制 3 的适用范围限定）；(4) Part D "不改代码"的克制结论。这份报告的问题不是能力问题，是**收尾校对和最后一公里调研**问题。

---

## 四、报告遗漏的现存缺陷与盲区（评审新增）

以下 3 项均为本次评审在源码中确认、而报告未覆盖的内容，可直接并入原报告 Part B/E：

### 新缺陷 1：设置变更后 discovery 不应用新配置（🔴 建议列入 P0）
见挑刺清单第 1 条。修复路径与报告 B.4 #1 天然合并：在 `IsolateSyncSettingsAction` 派发后追加 `IsolateDiscoveryRestartAction`（或在 `_runListener` 内监听 syncProvider 中 filter/timeout 相关字段变化后 break 出循环重启动）。注意 D-1 已提醒的坑：restart 走 `sendToIsolate(syncState: null)`（actions.dart:178-185），子 isolate 用的是**已同步**的 syncProvider 状态，顺序上必须保证 `_PublishSyncStateAction` 先于 restart 到达——同一 SendToIsolateData 通道内消息有序，需把两者做成"先 sync 后 restart"的复合 action，避免竞态。

### 新缺陷 2：事件通道满时静默丢弃已确认设备（🟠 建议并入 Part C 论证）
`DiscoveryState::found()` 用 `try_send` 优先保扫描不死锁（discovery/mod.rs:193-207），代价是通道满（16）时 `Discovered/Updated` 事件被 drop，仅 debug 级日志。子网扫描 255 探测 × 并发 50 的爆发密度下，UI 设备列表可能长时间缺人。这不是新提出的修复项，而是降级 1 的第二个论据 + 机制 2 症状（"设备时有时无"）的另一种成因。

### 新盲区 3：README 已经写明的三类经典失效被四个机制完全跳过
官方 Troubleshooting 表格里除 AP 隔离外还列了：**Windows 防火墙/专用网络**（报告只在机制 3 顺带一提）、**VPN**（"If a VPN is active, allow local/LAN traffic or temporarily disable the VPN"——VPN 虚拟网卡还会污染 localIps 排序，与机制 4 叠加）、**iOS 本地网络权限**（macOS/iOS "Local Network" permission 未授权时设备互不可见，这是 iOS 上"看不见设备"的第一大原因）。作为一份"排查顺序"（B.3）面向用户实操的报告，这三条必须在 B.3 的排查序列里占位。

---

## 五、拓展

### 拓展一：补缺失的失效机制（并入 Part B/C）

**机制 5（建议 ⭐⭐）：iOS/macOS 本地网络权限**
iOS 14+ 的 Local Network permission 是 per-app 授权，拒绝后 UDP 组播收发与局域网 HTTP 全部静默失败（无错误回调）。LocalSend 的组播 socket 恰好会"绑定成功但收不到任何公告"——receive_loop 无报错，MAX_CONSECUTIVE_RECEIVE_ERRORS 永不触发，表现与机制 1/2 高度相似但根因在系统授权。排查特征：设置页无任何网络活动 + 首次启动时未弹权限框。README 已列，报告 B.3 排查第 0 步应加"确认 iOS 本地网络权限已授予"。

**机制 6（建议 ⭐⭐）：VPN/虚拟网卡的三重叠加**
VPN 在报告里只出现在机制 4 的"后果"段。实际上它独立成环：(a) VPN 网卡 IP 参与 rankIpAddresses 排序且通常不以 `.1` 结尾、得分高于热点网段（加剧机制 4）；(b) VPN 的强制隧道策略直接丢弃局域网流量（README 明列）；(c) 组播 socket 逐接口绑定（socket.rs:38-57）会在 VPN tun 接口上也建 socket 并 announce，行为取决于系统路由——B.1 "全接口并发"的卖点在 VPN 场景恰恰是噪声源。修复建议与 B.4 #1 的"接口集合变化才触发"节流共用实现，另可在 InterfaceFilter 默认值里排除 tun/ppp 前缀接口。

**机制 7（建议 ⭐）：Doze/省电对组播接收的抑制**
Android Doze 与厂商省电策略会冻结 NSD/组播接收。LocalSend 前台服务仅覆盖传输进行中，待机期的 announce 监听可能被静默暂停——与机制 2 的"单接口静默死亡"在用户视角无法区分。这解释了报告未解释的一个现象：为什么"设备时有时无"总与屏幕息屏/待机相关。低成本缓解：发现层事件带 interface 标记上报（与 B.4 #4 同一改造），让"哪个接口、什么原因失联"可观测。

**机制 8（观察项）：发现协议无 mDNS/NSD 成分**
v2 协议的发现 = UDP 组播 announce（224.0.0.167 / ff12::fd3a:e420）+ HTTP register 应答，全程无 mDNS。这意味着 Android NsdManager / macOS Bonjour 浏览不能作为现成兜底，但反过来说：在组播被 AP 禁掉的网络里，Android 的 NsdManager 走的是同一套 mDNS 组播，同样救不了——**报告 B.4 修复清单里"扫描兜底"已是组播失效后的唯一普适路径**，这一点原报告的架构判断是对的，此处仅补全"为什么不引入 mDNS"的论证空缺。

### 拓展二：安全维度（并入 Part A）

1. **"指纹短哈希"不等于匿名**。报告 A.7 说"标识符要轮换，别直接广播稳定 fingerprint"，方向对但不彻底：对稳定 fingerprint 做无盐短哈希仍是可链接标识符（AirDrop 的联系人哈希正是被 USENIX Sec'19 拿哈希字典攻破的）。L1 的广播载荷建议：每 N 分钟轮换的随机 UUID + 可选的收发双方带外短码匹配（如 4 位 PIN 的 HMAC），fingerprint 永不出现在空口。
2. **L1 的安全边界在代码里有现成锚点**。发现链路的信任模型当前是：probe 用不 pin 证书的 client（discovery/mod.rs:142-152 `unpinned_client`，注释明言 fingerprint 之后再 pin）→ HTTPS 应答的 fingerprint 取自证书而非 body（:168-176）→ answer_announcement 按公告中声称的 fingerprint 预置 pinning（:519-527）。BLE L1 若只喂"候选地址"给 `DiscoveryHandle::discover`，安全模型**零改动**——这是报告 A.5 L1 "不动安全模型"结论的代码级佐证，原报告没给出这三处锚点，补上后论证闭环。
3. **BLE 广播引入的新攻击面**：伪造广播让 A 设备向攻击者控制的地址发 register probe（放大探测+日志投毒）。缓解：probe 结果进入 store 前的入口都经过 HTTP TLS（BLE 只提供候选地址，不提供信任），投毒上限是"无效地址探测失败"，无信任提升——但建议在 L1 设计里限制 BLE 触发的 probe 频率，避免被用来放大电量消耗。
4. **回归锚点**：v2_tls_pinning.rs 验证"客户端在写入任何请求数据前完成对端证书认证"（该文件 doc 原文）。任何 L1/L2 改动跑这个测试是硬门槛，报告 Part F 已列，此处置评确认。

### 拓展三：上游贡献路径（并入 Part G，含一条红线）

1. **🔴 红线：CONTRIBUTING.md 明文限制 AI 生成贡献**——"LocalSend disallows AI generated contributions unless: they are bug fixes or very small or you prove your expertise in your field"。对照 Part G：P0/P1 是 bug fix（合规）；**P3 的 BLE 原型 PR 直接踩线**——新功能、不小、且若由 AI 主导生成则三类豁免都不沾。落地前必须：由人类主导设计并逐行理解、PR 描述如实说明工具使用、先开 issue 附原型设计文档征询维护者意见（维护者在 #427 的原话是"有 prototype 欢迎来 share"，说明 issue+原型文档的组合是他的偏好输入）。报告 Part G 完全没查这条政策，属于落地调研的重大疏漏。
2. **测试纪律**：AGENTS.md:80 明言 core crate 裸 `cargo check` 会失败（模块无条件声明但依赖是 optional 的），必须 `cargo test --features full` / `cargo clippy --features full`；Dart 侧用 `fvm flutter analyze` / `fvm flutter test`。报告 Part F 的测试清单应补上这两条命令级要求，否则贡献者本地第一轮验证就会卡在环境上。
3. **PR 拆分建议**（细化报告 Part G）：
   - PR-1（P0，纯 Dart）：Windows 网络变化订阅/轮询 + 全平台 resumed 重绑（main.dart:63-74）+ 设置变更触发 restart（新缺陷 1 修复）。三个触发点共用 `IsolateDiscoveryRestartAction`，不碰 Rust。
   - PR-2（P0，纯 Dart）：`.1` 排序例外 + maxInterfaces 调整 + 同步更新 network_info_provider_test.dart 的 4 条断言（C-1 风险落地为"测试用例同步改"）。
   - PR-3（P1，Rust+Dart）：机制 2 单接口上报与重建。注意 api/discovery.rs 的 `DiscoveryEvent` 通道容量 16（:192）与 event_backpressure.rs 的既有约束，新增事件变体先扩通道压测。
   - PR-4（P3）：BLE L1 原型 issue + 设计文档（含拓展二的标识符轮换方案），拿维护者背书后再动代码。
   - 每个独立 PR 对应报告 E.2 陷阱清单的一个子集，避免"一个 PR 改完 #4/#5/#7/#8 + 排序 + 测试"的大杂烩——那正是报告自己警告的"改一半"温床。
4. **版本窗口**：main 分支当前活跃度高（HEAD 为 2026-10-03 的 #3472），发现链路代码近期持续重构中（v2.2 协议、isolates 架构都是新的）。P0 修复宜基于 main 最新 HEAD 而非报告拉取时的快照，PR 前重新校验行号——本评审发现的 6 处行号错标，部分即可能源于快照与最新 HEAD 的漂移。

---

## 六、修订后的落地顺序（在原报告 Part G 基础上增补）

| 阶段 | 内容 | 相对原报告的变化 |
|---|---|---|
| **P0+** | 原 P0 全部内容 + **新缺陷 1**（设置变更触发 discovery 重启，与机制 1 修复同一 PR） | 增补：把"改一半风险 D-1"升级为待修缺陷 |
| **P0** | 原 P0 其余内容（`.1` 排序例外 + 测试同步更新） | 不变，但按 PR-2 拆分执行 |
| **P1** | 机制 2 单接口上报/重建 + 事件通道丢弃可观测性（新缺陷 2 的计数器/日志） | 增补可观测性子项 |
| **P1.5** | B.3 排查序列补 README 三条（防火墙/VPN/iOS 本地网络权限）+ UI 在 >3 接口时给出"正在扫描前 3 个网段，其余需手动选择"的明示 | 纯 UX/文档，零风险 |
| **P2** | 降级 1/2 自适应（强调超时已有手动入口，代码价值在自适应而非放宽） | 论证修正 |
| **P3** | BLE L1：issue + 设计文档先行，明确 AI 贡献政策合规路径与标识符轮换方案 | 增加合规前置条件 |
| **不做** | 维持原判（双频应用层聚合、L3 蓝牙直传） | 不变 |

## 七、评审结论

原报告以单人之力把一条跨 Rust/Dart 的异步发现链路拆到了行号级，四个失效机制全部经得起源码复核，E.2 陷阱清单 12/12 成立，这在同类报告中属于前 5% 的水准。它的失分点集中且可修：**6 处行号错标暴露了缺少最后一轮机械校对；机制 4 与降级 2 各漏了一个改变结论强度的代码事实；把一个现存 bug 当作未来风险；以及 Part G 在落地调研上没有翻 CONTRIBUTING.md——而那里恰好写着决定 P3 生死的条款**。

一句话总评：**论点可信、证据扎实、结论克制，但"行号级精确"的人设要求它不能容忍 6 处错标，"落地导向"的人设要求它不能不查贡献政策。** 按第六节增补后，这份报告可以从"优秀的分析文档"升级为"可以直接指导 PR 序列的工程文档"。
