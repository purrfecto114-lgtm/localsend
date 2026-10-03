# 《LocalSend 传输优化总报告》独立评审报告（v2.0 定稿）

**评审对象**：《LocalSend 传输链路优化总报告》（蓝牙辅助传输 · 双频/热点异常 · 2.4GHz 降级 · 双频智联加速 · 调用链与回归风险）
**评审基准**：localsend/localsend `main` 分支 commit `9529e915`（2026-10-03），app `1.18.2+64`，与报告声称的基线为**同一 commit**，无版本漂移
**评审流程**：主审逐条比对 → 5 视角 subagent 评审团（源码事实核查员 / 网络协议专家 / 魔鬼代言人 / 安全审查员 / 上游贡献者，均加载 superpowers 工作流技能）独立反审查 → 主审整合 43 条修正意见定稿。v1 → v2 的实质变化见第七节
**可审计口径**：原报告全文 `文件:行号` 引用经 grep 统计为 **79 处**；主审逐条核查约 60 处，事实核查员独立抽验 40+ 处，两轮合计确认 **7 处行号错标**（第三节），其余引用精确或在 ±1~4 行内。本环境无 Rust/Flutter 工具链，编译期断言以静态分析定论。**scope 声明**：本评审覆盖源码可验证断言与工程落地路径；原报告 Part C/D 引用的外部性能数据（[citation:N] 体系）仅做可信度框架评价，未逐项溯源
**评审立场**：事实优先。报告写对的地方明确承认，写错的地方给出行号级证据；评审自身被评审团抓出的错误在第七节如实披露

---

## 一、总体评判

先说结论：**这是一份高质量的源码级报告，四个失效机制全部成立、E.2 陷阱清单 12 处实质全部成立，但存在 7 处行号错标、2 处定性偏差、1 处论据链断裂，遗漏了 2 个现存缺陷和 1 个两份报告共同的最大盲区（Android MulticastLock），并且完全没查 CONTRIBUTING/AGENTS.md——那里有直接决定 BLE 原型 PR 生死的 AI 贡献限制条款。**

| 维度 | 评分 | 依据（可审计口径） |
|---|---|---|
| 引用精度 | ★★★★☆（4/5） | 79 处行号引用，两轮独立核查确认 7 处错标（1 处偏 7 行，6 处偏 1~4 行），其余精确或在 ±4 行内 |
| 机制成立性 | ★★★★★（5/5） | Part B 四机制全部在源码中找到确凿支撑；机制 2 的归因链条经协议专家修正后依然成立且更完整（见拓展一） |
| 论证完整性 | ★★★☆☆（3/5） | 机制 4 漏 UI 子网选择兜底（send_tab.dart:331 + 349-354）；降级 2 漏"超时已是用户可配置项"；"唯一已就绪"为措辞不严谨 |
| 缺陷挖掘深度 | ★★★★☆（4/5） | E.2 陷阱清单 12 处实质全部成立（其中 #9/#10 行号有 2~4 行偏移），但漏第 13 处运行时断言（nearby_devices_provider.dart:87），且把一个**现存 bug** 仅当作"改一半风险" |
| 外部引文可信度 | ★★★☆☆（3/5） | 4 个 GitHub issue 与维护者引言**逐字属实**（在线核验）；但 [citation:N] 编号体系不可解析，Part C/D 的定量数据（87% 占用、747 vs 506 Mbps 等）全部无法追溯——issue 层可信 ≠ 数据层可信，数据层本次未审 |
| 落地可行性 | ★★☆☆☆（2/5） | P0/P1 排序合理，但未查 CONTRIBUTING.md 与 AGENTS.md 的 AI 贡献政策（2026-07-25 加入），未检查 git 历史中维护者的两个关键刻意设计（main.dart iOS-only 门、`.1` 排序启发式），PR 策略需要重排 |

**摘要表逐条复核**：摘要 6 条结论全部成立。"4 个机制，其中 3 个是代码缺陷"的表述与源码一致——机制 1/2/4 是代码行为缺陷，机制 3 是设计约束（TTL=1 显式表达"发现仅限本地链路"，跨 VLAN 即使 TTL>1 也需要组播路由协议支撑）。

---

## 二、逐条核实表

图例：✅ 完全属实 ｜ 🟡 实质成立但行号/表述有偏差 ｜ ❌ 错误

### Part A 蓝牙辅助传输（11 项断言：10 项属实，1 项存疑）

| # | 报告断言 | 核实结果 | 证据 |
|---|---|---|---|
| A-1 | `store.rs:125` DeviceChannel 注释点名 WebRTC/Bluetooth | ✅ | `packages/core/src/discovery/store.rs:123-131`，doc 注释逐字一致（enum 声明在 128 行，报告指到注释区，可接受） |
| A-2 | `StatefulDevice.channels: HashMap<DeviceChannel, ChannelStatus>` | ✅ | store.rs:50 |
| A-3 | `ChannelStatus::{Available, NotReachable}` | ✅ | store.rs:60-67 |
| A-4 | `get_ranked_channels()`（store.rs:97），排序 = 可用性 → IPv6 → 最近确认 | ✅ | store.rs:97-107，sort key 为 `Reverse((available, is_ipv6, last_confirmed))`。**补充**：IPv6 优先于 IPv4 是刻意行为（测试 `test_get_channel_prefers_ipv6_over_ipv4` 证实），报告未点明方向，对 Part D 双栈场景有影响 |
| A-5 | `DiscoveryHandle::add_device()`（discovery/mod.rs:395），注释"供 discovery 之外确认的设备使用" | ✅ | mod.rs:391-395 精确，doc 原文 "Puts a device confirmed outside of discovery into the store" |
| A-6 | WebRTC：`webrtc.rs`(1428行) + `signaling.rs`(528行) | ✅ | `wc -l` 实测 1428 / 528，分毫不差 |
| A-7 | `const webRTCEnabled = false;` | ✅ | signaling_provider.dart:22；使用点 init.dart:238 |
| A-8 | `SignalingChannel` 已是 Dart 侧 DeviceChannel 第二变体 | ✅ | device.dart:16 `sealed class DeviceChannel`、:22 HttpChannel、:38 SignalingChannel |
| A-9 | issue #144/#427/#850/#2924 标题与时间 | ✅ | 在线核验属实；#427 为 Discussion、创建于 2023-04-29 |
| A-10 | Tienisto 引言 *"the bluetooth API is not easy to work with..."* | ✅ | discussion #427 页面逐字命中，"Wi-Fi Aware" 提及同样命中 |
| A-11 | flutter_blue_plus 覆盖含 **Web** 在内的全平台 | 🟡 | 仓库内无法核验且无出处引用；其官方支持矩阵中 Web 支持历来非完整一等公民。按报告自己的标准应标"待核实" |

### Part B 双频/热点传输异常（15 项断言：12 ✅，1 🟡 行号，1 ❌ 日志细节，1 🟡 结论过强）

| # | 报告断言 | 核实结果 | 证据 |
|---|---|---|---|
| B-1 | 每个非回环 IPv4 地址一个 socket，注释逐字引用 | ✅ | socket.rs:24-25 逐字命中；`local_interfaces` 明确跳过 loopback（interface.rs） |
| B-2 | `set_multicast_if_v4`（socket.rs:109-111） | ✅ | :111 精确 |
| B-3 | 每 socket 独立 receive_loop（multicast/mod.rs:290-297） | ✅ | :289-297 |
| B-4 | HTTP 服务端绑 `0.0.0.0` 与 `[::]`（http/server/mod.rs:230-238） | ✅ | :230、:237 |
| B-5 | 重绑触发点全仓库仅 2 处（main.dart:72、settings_tab_controller.dart:149） | ✅ | 全仓 grep 恰 2 处 dispatch；main.dart:70-73 iOS-only；**注意第二处是设置页手动「重启服务」按钮**（onTapRestartServer），非"保存"动作 |
| B-6 | Windows 被排除在网络变化监听外（local_ip_provider.dart:49-56） | ✅ | 逐行命中，issues #12/#78 注释引用也在 |
| B-7 | `MAX_CONSECUTIVE_RECEIVE_ERRORS = 10`（mod.rs:58），超限 return 永久放弃 | ✅ | :58；receive_loop :350-362 |
| B-8 | `SocketsFailed` 只在全部 socket 挂掉才发（mod.rs:301） | ✅ | :299-308 |
| B-9 | `set_multicast_ttl_v4(1)`（socket.rs:118） | ✅ | 精确 |
| B-10 | `/24` 扫描兜底（discovery/mod.rs:342） | ✅ | `scan_subnet` 精确在 342 |
| B-11 | `maxInterfaces = 3`（scan_facade.dart:**22**）+ take(3) | 🟡 | 实质属实，但 `maxInterfaces = 3` 在**第 15 行**、`take(maxInterfaces)` 在**第 21 行**，报告的两处行号皆不中，且把两个位置的代码拼进同一代码块共用一个行号 |
| B-12 | `.1` 排最后（local_ip_provider.dart:129-136） | ✅ | scoreA/scoreB 在 :132-133。**且实际更严重**：`getWifiIP()` 返回的 `.1` 网关地址走 `_rankIpAddresses(null)` 分支（:116-118）同样排最后——Android 热点场景连本机 AP 地址都被降权，报告的论证还可以更狠 |
| B-13 | 机制 2 表现"日志只有一条 warn" | ❌ | 每次接收错误一条 warn（:352-355）+ 放弃时一条 error（:357-360），10 次失败 = 10 warn + 1 error。原报告**低估**了日志量；实操后果反而是日志易查——错误方向对，量级写反 |
| B-14 | 机制 4 后果"热点网段进不了前 3 → 兜底不扫 → 全盘失联" | 🟡 | 自动路径属实：`SendTabInitAction`（send_tab_vm.dart:223-234）在设备列表为空时无条件派发 StartSmartScan 只取前 3。**但报告漏了 UI 兜底**：接口数 > 3 时手动刷新按钮变为子网选择弹窗（send_tab.dart:331 条件 + :349-354 弹窗与 `StartLegacySubnetScan(subnets: [ip])` 派发），用户可手动扫热点网段——虽然该入口对普通用户不可发现、且一次只扫一个网段。"全盘失联"应改为"自动发现系统性遗漏 + 补救入口不可发现" |
| B-15 | 官方 troubleshooting 第一条关 AP 隔离、Windows 专用网络 | ✅ | README.md Troubleshooting 表格第 1、2 行逐字命中 |

### Part C 单频 2.4GHz 降级（常量与代码引用全部精确，2 处论证完整性问题）

| # | 报告断言 | 核实结果 | 证据 |
|---|---|---|---|
| C-1 | `SCAN_CONCURRENCY = 50`（discovery/mod.rs:33），255 并发探测 | ✅ | :33；`buffer_unordered(SCAN_CONCURRENCY)` |
| C-2 | `DEFAULT_DISCOVERY_TIMEOUT = 500ms`（mod.rs:26） | ✅ | 精确；Dart 侧 `defaultDiscoveryTimeout = 500`（constants.dart:19）双侧一致 |
| C-3 | ":71 注释"约束单个无响应主机拖慢扫描 | ✅ | :70-72 原文命中 |
| C-4 | `ANNOUNCE_DELAYS = [100ms, 500ms, 2000ms]`（mod.rs:45） | ✅ | :45-49 精确 |
| C-5 | 降级 2：建议放宽超时 | 🟡 | **遗漏关键事实：发现超时已是高级设置里用户可调的现成选项**（settings_tab.dart:466-478 → `IsolateSyncSettingsAction` → discovery.dart:78）。"放宽"零代码可做到；代码改动的价值在"按链路质量自适应"。**另注**：改了超时同样要等 discovery 重启才生效（timeout 只在 start_discovery 传入一次）——零代码方案也逃不过第四节的新缺陷 1 |
| C-6 | 降级 1"255 并发探测流量风暴/正反馈恶化" | 🟡 | 并发事实属实，"正反馈"为无实测的合理推断。**报告漏了更强的论据**：HTTPS 模式下每个探测都是完整 TLS 握手 + RSA-2048 客户端证书，2.4G 高 RTT 下握手延迟比带宽更致命；且 `found()` 用 `try_send` 发事件、通道容量仅 16、满即丢弃（discovery/mod.rs:193-207 + api/discovery.rs:192）——风暴下 UI 还会漏显已确认设备 |
| C-7 | 降级 4：device_list_tile 已有条件渲染能力 | ✅ | :56-75 三态布局属实 |

### Part D 双频智联加速（结论稳，补一个反例风险）

D-1（channels HashMap 按 endpoint 合并）、D-2（`get_ranked_channels` 只取最优、无并行聚合，`toDevice()` 取 `channels.first`）、D-3（情形 1/2/3 分层）全部与源码一致：store.rs:196-229、rust.dart:137-150、send_provider 只用 `target.ip`。**"情形 2 是唯一值得改代码的加速点"判断成立。**

**补充反例风险（报告未展开）**：`get_ranked_channels` 把 IPv6 排前（store.rs:102），而 Dart 兜底扫描明确忽略 IPv6（local_ip_provider.dart:101 `// ignore IPv6 for now`）。对端双栈且本机 IPv6 路由质量差时，最优通道选择可能系统性偏向更差链路——与"双频"无关，但与"链路选择"强相关。

### Part E 调用链与"改一半"风险清单（24 处行号断言全部核实，E.2 十二处陷阱：10 ✅ + 2 🟡）

五条链路（发现启动 / 重绑 / IP 排序→兜底扫描 / 设置同步 / 设备确认→传输）的行号断言经两轮核查全部属实，含少量 ±1~3 行偏移（init.dart:190、discovery.dart:28/:37/:59、event_backpressure.rs:27 等，全表见第三节错标清单）。

**E.2 陷阱清单判定：10 处 ✅ + 2 处 🟡（#9 favorite_device.dart:16 实为 :12；#10 device.dart:56 实为 :58——实质成立、行号偏移）。** 核心断言全部经得起复核：

- #4/#5 "不可反驳 let"（api/discovery.rs:441、:464）：静态分析确认。单变体 enum 使 `let DeviceChannel::Http(http) = ...` 当前不可反驳，新增变体立即报 E0005，且两处都是非 pub 内部函数，编译器不会主动提醒。
- #7/#8 运行时崩溃路径成立（rust.dart:137-141 `channels.first`/`best.host`；send_provider.dart:263/:733 `target.ip!`）。
- **但清单漏了第 13 处**：`nearby_devices_provider.dart:87` `assert(device.ip?.isNotEmpty ?? false, 'IP must not be empty')`——蓝牙设备 ip==null 时 debug 模式在此更早崩溃；release 模式 assert 剥离后才轮到 `target.ip!`。相应地，#12 "device_list_tile 是唯一已就绪的地方"应降格为"措辞不严谨"：`DiscoveryService.addDevice`（discovery.dart:214-222）对 null ip 做了跳过并记日志——是"优雅降级"而非"能正常展示"，两种读法下"唯一"都过强。

### Part F 回归风险清单（6 项：5 ✅/🟡，1 项需补充关键盲区）

| # | 报告断言 | 核实结果 |
|---|---|---|
| F-1 | network_info_provider_test.dart 测 rankIpAddresses、`'222.1'` 排最后断言 | ✅ :5-19，断言在 :7，改排序必红 |
| F-2 | network_interfaces_test.dart | ✅ 存在 |
| F-3 | core 侧 5 个测试文件 | ✅ 全部存在（另注：packages/core/tests/ 实有 10 个测试文件，connections.rs、internal_server.rs、v2_server.rs、v2_web_download.rs、hash.rs 未在报告评估范围） |
| F-4 | event_backpressure.rs CHANNEL_CAPACITY=16 | 🟡 常量在 :27（报告 :29），"both event channels" 注释 :26；两个测试名与描述吻合 |
| F-5 | MULTICAST_CHANNEL_SIZE = 64（discovery/mod.rs:29） | ✅ 精确 |
| F-6 | "改 socket 绑定必跑 multicast.rs" | 🟡 方向对但有盲区：**tests/discovery.rs:7-9 明言组播测试在环境不支持时 self-skip 而非 fail**——CI 无真实组播环境时"必跑"测试静默跳过，改坏 socket 绑定 CI 可能全绿。安全网本身有洞，报告未检查 |

### 引用体系问题（跨 Part，❌ 级）

1. **路径书写歧义**：`api/discovery.rs` 全文未写全路径，真实位置 `packages/localsend_isolates/rust/src/api/discovery.rs`——不在 `packages/core` 里；`multicast/*` 同样未写全路径。对以"调用链全景"为卖点的报告是硬伤。
2. **[citation:N] 不可解析**：正文 14 个编号仅做松散成组映射，出现 `[citation:4-旧]` 这种无法对应的写法。

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

### 拓展三：上游贡献路径（并入 Part G；本节经上游贡献者用 git 历史逐项复核后重写）

1. **红线确认与扩大：AI 贡献政策不止在 CONTRIBUTING.md**。CONTRIBUTING.md:5-9 原文属实（"disallows AI generated contributions unless: they are bug fixes or very small or you prove your expertise in your field"）；`git log -S` 溯源显示该政策由维护者 2026-07-25（commit 4199cfd8）加入，**同一 commit 在 AGENTS.md 开头逐字重复**（CLAUDE.md 仅引用 AGENTS.md）——对 AI agent 而言 AGENTS.md 才是必读位，红线只会更硬。**解读裁定**：三条豁免是字面 OR 关系，但逐项对照后不能像初稿那样一刀切"P0/P1 合规"——PR-1（设置重启）是无争议 bug fix；**PR-2（`.1` 排序例外）是修改维护者 2023 年（338f9a725）刻意实现、被 4 个测试钉死的行为**，援引"bug fix"豁免属于钻字面空子，被驳回风险高；PR-3（单接口上报）是新增基础设施，属增强。**更稳的合规路径不是援引豁免，而是不落入定义**：人类执笔设计与逐行验证、AI 仅作分析辅助、PR 描述如实披露工具使用与人工验证范围——即不构成 "AI generated"。
2. **初稿 PR 拆分的问题（git 历史证据）**：该仓库 commit 全部单一目的、外部可见修复多为 1-2 文件（如 63efbe6b 仅 +42 行/2 文件），初稿 PR-1"三合一"超出评审粒度预期。更关键的是两个子项在逆着维护者的刻意设计：
   - **Windows 网络监听**：local_ip_provider.dart:49-56 是维护者**刻意**跳过（注释引 issue #12/#78 的历史故障），恢复它是 feature 级改动，必须 issue 先行、单独走，不能塞进 bug fix PR。
   - **全平台 resumed 重绑**：`git blame main.dart:70-72` 显示 iOS-only 门是维护者 **2026-08-18（63efbe6b）刚加的**，注释明言多播 socket "cannot be probed, so always rebind them"；同 commit 给 Android 的是探活式 `ensureRunning()`。全平台无条件重绑 = 推翻 6 周前的设计而不回应其理由，必被一眼反问。对齐维护者哲学的替代方案：**利用已开启的组播回环 + own message 按 fingerprint 自过滤（socket.rs:113-115、mod.rs:376-378）做轻量探活**——own-echo 本身就是免费的组播存活信号，符合"Android 可探测就探测"的设计语言。
   - **PR-3（机制 2）需改写为"扩展既有自愈设施"**：89303dcf（2026-08-17）已加入 `multicastError()` 上报与"全部 socket 死亡 → 1 秒退避自愈重启"循环；单接口上报应并入该基础设施与既有事件枚举（遵守 AGENTS.md "新交互扩展既有事件而非旁路通道"、通道容量 16 约束），而非另起并行机制。
3. **初稿"快照漂移"推测不成立，删除**：HEAD 9529e915 = 报告基线 = 评审 checkout，同一 commit；错标文件的最后修改时间均在 2026-08-24 之前（init.dart 的 10/2 提交 hunk 在 190 行之后、不产生位移）。错标的根因就是未做机械校对，与漂移无关。"PR 前重新校验行号"作为通用卫生保留，但理由撤回。**补充利好**：发现链路代码自 8 月下旬冻结、v2 工作区重构已落地——当前是稳定维护期，恰是贡献窗口（初稿"重构进行中"的判断已过时）。
4. **替代首发序列（issue × 2 → PR × 3，每步可独立被接受/拒绝）**：
   - **Issue 1 → PR-1（≤20 行 + 测试）**：设置变更不作用于运行中 discovery 的 bug 报告（附复现路径 + 三处 doc 注释作为设计意图证据）→ 修复为 onChanged 内 sync 后顺序 dispatch restart，遵循 `fix:` 惯例。
   - **PR-2（小）**：Android resumed 的 discovery 处理——按第 2 点的探活方案对齐维护者哲学，issue 里先给 Android 侧 socket 死亡的实测证据（❓ 需实机）。
   - **Issue 3 → PR-3（feature）**：Windows 网络变化感知（先查 #12/#78 当年排除原因，给轮询/平台通道两个备选）。
   - **Issue 4（heuristic gap 提案）**：`.1` 排序——附热点拓扑数据与"自动发现遗漏 + 弹窗不可发现"的 UX 论证，坦承这是改 2023 年的刻意行为；测试同步更新随 PR 走。
   - issue 话术要点：引用维护者自己的 commit（63efbe6b/89303dcf/338f9a725）表明对齐而非推翻；给最小复现 + 行号级路径；PR ≤100 行、`fvm flutter analyze/test` + `cargo test/clippy --features full`（AGENTS.md:80 明言裸 `cargo check` 会因 feature 门失败）、"All changes should be covered by tests"。

---

## 六、修订后的落地顺序（对原报告 Part G 的增补与修正）

| 阶段 | 内容 | 相对原报告的变化 |
|---|---|---|
| **首发 PR** | 新缺陷 1：设置变更触发 discovery 重启（bug fix，≤20 行，issue 先行） | 原报告无此项；由"改一半风险 D-1"升级 |
| **P0** | `.1` 排序例外 + maxInterfaces（issue 先行，heuristic gap 提案，测试同步更新） | 按 git 历史重新定性，不能再走 bug fix 通道 |
| **P0.5** | B.3 排查序列补 README 三条（防火墙/VPN/iOS 权限）+ MulticastLock 评估 + UI 在 >3 接口时明示"仅自动扫描前 3 个网段" | 纯文档/UX；UI 半项需 issue 先行，"零风险"表述撤回（涉及 i18n 与 maxInterfaces 耦合） |
| **P1** | 机制 2 单接口上报/重建：并入 89303dcf 既有自愈设施，扩展事件枚举，通道容量 16 压测 | 由"另起机制"改为"扩展既有设施" |
| **P1.5** | Windows 网络变化感知（feature，轮询/平台通道两备选） | 从 P0 拆出并降级为 feature 级 issue 先行 |
| **P2** | 降级 1/2 自适应（超时已有手动入口，代码价值在自适应；HTTPS 探测握手成本一并考虑） | 论证修正 |
| **P3** | BLE L1：issue + 设计文档先行，明确 AI 贡献政策合规路径（人类主导 + 披露）、标识符轮换与匹配链设计、Android BLE 权限模型 | 增加合规与设计前置条件 |
| **不做** | 维持原判（双频应用层聚合、L3 蓝牙直传） | 不变 |

---

## 七、评审过程与自我修正记录（v1 → v2）

本评审采用"主审 + 5 视角 subagent 评审团"双环流程：主审逐条核查后产出 v1，评审团（源码事实核查员 / 网络协议专家 / 魔鬼代言人 / 安全审查员 / 上游贡献者，各自加载 superpowers 工作流技能）对 v1 独立反审查，共产出 43 条意见。按"评审别人行号精度的人，自己也不能例外"的标准，如实披露 v1 被抓出的主要问题及处置：

| # | v1 的问题（评审团发现） | v2 处置 |
|---|---|---|
| 1 | "6 处行号错标"实列 7 处，计数与自列清单矛盾 | 全文统一为 7 处，给出 79 处总量的可审计口径 |
| 2 | "E.2 12/12 属实"与错标清单双重计入（#9/#10 行号有偏移） | 改为"10 ✅ + 2 🟡"，口径显式化 |
| 3 | 头号指控的逃逸路径写错："或改端口"不触发任何重启；"设置页保存"应为"重启服务按钮" | 已修正，并补 socket 失败自愈路径的细微限定（"纹丝不动"略过强：组播全灭时的自愈重启会以新 syncState 生效） |
| 4 | 83%/95%/22 处/24 处等统计无法复算 | 全部替换为可审计计数（79 处总量、7 处错标、两轮覆盖说明） |
| 5 | B-13 裁决措辞反了（"会找不到 warn"，实际是 10 warn + 1 error 易查） | 改为"低估日志量，方向对量级反" |
| 6 | send_tab.dart 证据区间 331-347 不含其引用的 349-354 代码 | 引文改为 331 + 349-354 |
| 7 | AirDrop 哈希攻击引文错误（误写 USENIX Sec'19） | 改为 2019-05 披露 + PrivateDrop（USENIX Sec'21）+ AirCollect（WiSec'21） |
| 8 | "probe 结果进 store 前都经过 TLS"是全称命题错误，HTTP 模式下 store 入口无认证 | 按模式限定重写，并补服务端 /register 注入与同指纹通道劫持两条更重攻击面 |
| 9 | "Doze 冻结 NSD"、"行为取决于系统路由"、"iOS 收发全静默"三处系统行为不严谨 | 分别修正（NSD 豁免；出口被 set_multicast_if_v4 钉死；接收静默但发送 EPERM 可观测，标 ❓ 待实机复核） |
| 10 | 对自身机制 5/6/7 的外部断言未标"待核实"（双重标准） | 补 ❓ 标注与 entitlements/Android 17 权限代码流等源码内证据 |
| 11 | "前 5%"等不可证伪表述；四~六节约三成篇幅实为 rewrite 未声明 | 删除；拓展章节显式标注"建议稿"属性 |
| 12 | 漏掉 init.dart:212-220 Android 本地网络权限申请流（本可加强机制 5） | 已纳入新盲区 3 |
| 13 | PR 拆分未对照 git 历史中维护者的两个刻意设计 | 拓展三按 git blame/glog 证据重写 |
| 14 | "快照漂移"推测与自己的"机械校对"诊断矛盾 | 删除推测，保留校对建议 |

评审团的总体裁定：v1 的 4 个"新发现"经反例攻击全部幸存（其中新缺陷 1 被穷尽 6 条反例路径后确认为真），对原报告的 7 处行号纠错全部复核属实，约 90 处自身行号引用除上表所列外全部命中。

---

## 八、评审结论

原报告把一条跨 Rust/Dart 的异步发现链路拆到了行号级：四个失效机制全部经得起源码复核与反例攻击，E.2 陷阱清单 12 处实质成立，外部 issue 引文逐字属实。它的失分点集中且可修：**7 处行号错标暴露收尾校对缺失；机制 4 与降级 2 各漏一个改变结论强度的代码事实；把一个被三处 doc 注释自证的现存 bug 当作未来风险；共同盲区 MulticastLock 说明它没有做跨层（App 权限层）检索；而 Part G 没有翻 CONTRIBUTING/AGENTS.md、没有查 git blame，导致 PR 策略逆着维护者刚做的设计走**。

一句话总评：**论点可信、证据扎实、结论克制；但"行号级精确"的人设要求它不能容忍 7 处错标，"落地导向"的人设要求它不能不查贡献政策与 git 历史。** 按第六节修正后，这份报告可以升级为可直接指导 issue/PR 序列的工程文档——它的分析层已经是前述水准，欠的是最后一公里的校对与调研。
