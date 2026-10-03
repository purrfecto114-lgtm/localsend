
### Part C 单频 2.4GHz 降级

| # | 报告断言 | 核实结果 | 证据 |
|---|---|---|---|
| C-1 | `SCAN_CONCURRENCY = 50`（discovery/mod.rs:33），`/24` 扫描并发 255 探测 | ✅ | mod.rs:33；`scan_subnet` 对 `0..=255` 除自身外逐个 probe，`buffer_unordered(SCAN_CONCURRENCY)` |
| C-2 | `DEFAULT_DISCOVERY_TIMEOUT = 500ms`（discovery/mod.rs:26） | ✅ | 精确；Rust doc 注释 "answer quickly or not at all" 与报告引文一致；Dart 侧 `defaultDiscoveryTimeout = 500`（localsend_isolates/lib/constants.dart:19）双侧一致 |
| C-3 | ":71 注释"该常量同时约束单个无响应主机拖慢扫描 | ✅ | mod.rs:70-72 "Bounds how long an unresponsive host stalls a subnet scan, so keep it short" |
| C-4 | `ANNOUNCE_DELAYS = [100ms, 500ms, 2000ms]`（multicast/mod.rs:45） | ✅ | mod.rs:45-49 精确；announce() 循环为 sleep→send 三连发 |
| C-5 | 降级 2 建议放宽超时至 1500-2000ms | 🟡 | **方向正确但遗漏关键事实：发现超时已经是高级设置里用户可调的现成选项**（settings_tab.dart:466-478 的 discoveryTimeout 输入框 → `setDiscoveryTimeout` → `IsolateSyncSettingsAction` 下发 → discovery.dart:78 `timeoutMs: BigInt.from(syncState.discoveryTimeout)`）。"把超时放宽"不需要改一行代码，改代码的真正价值是"按链路质量自适应"，报告把零代码方案和代码方案混在一个建议里，P2 的必要性论证因此不完整 |
| C-6 | 降级 1"255 个并发探测形成流量风暴/正反馈恶化" | 🟡 | 并发事实属实；"正反馈"为合理推断但无实测数据支撑。**报告没提的放大器**：`DiscoveryState::found()` 用 `try_send` 发事件、通道满即**丢弃**（discovery/mod.rs:193-207，注释明言 "Dropping an event only costs a refresh"），事件通道容量仅 16（api/discovery.rs:192 `mpsc::channel::<DiscoveryEvent>(16)`）——扫描风暴下不只是带宽竞争，UI 还会**漏显已确认设备**，直到下次重新确认才出现。这既强化降级 1 的论据，也解释了"扫到了但列表里没有"的另一类用户抱怨 |
| C-7 | 降级 4：device_list_tile.dart 已有条件渲染能力 | ✅ | device_list_tile.dart:56-75 的三态布局属实 |

**Part C 判定**：常量与代码引用全部精确。C-5、C-6 两处属于"论证完整性"问题而非事实错误：一个漏了现成的用户级配置入口，一个漏了同源的事件丢弃机制（它本可以让降级 1 的论证更有力）。

### Part D 双频智联加速

| # | 报告断言 | 核实结果 | 证据 |
|---|---|---|---|
| D-1 | `channels` 是 HashMap、按 endpoint 合并，跨网段双频天然能收集两条 | ✅ | store.rs:196-229 `upsert` 的 `same_endpoint` retain/insert 逻辑；测试 `test_upsert_collects_channels_of_a_multi_homed_device` 证实多通道共存 |
| D-2 | `get_ranked_channels()` 只取最好一条用，无并行聚合 | ✅ | rs_stored_device（api/discovery.rs:459-483）输出排序后的 channels 全量；rust.dart:137-150 `toDevice()` 取 `channels.first` 作为 ip/port；传输侧（send_provider）只用 `target.ip`。**应用层确实无任何并行聚合**，"情形 2 是唯一值得改的加速点"判断成立 |
| D-3 | 情形 1/2/3 的分层判断 | ✅ | 与代码结构一致；Link Turbo 需系统级 MP-ATP 属外部事实，标注合理 |

**Part D 判定**：结论稳。补充一点报告未展开的**反例风险**：`get_ranked_channels` 把 IPv6 排在 IPv4 之前（store.rs:102），而 Dart 侧兜底扫描明确忽略 IPv6（local_ip_provider.dart:101 `// ignore IPv6 for now`）。若对端双栈且本机 IPv6 路由质量差（常见于 2.4G + 隧道式 IPv6），最优通道选择可能系统性偏向更差的链路。这与"双频"无直接关系，但与"链路选择"强相关，报告 Part D 的通道排序讨论漏了这个维度。

### Part E 调用链与"改一半"风险清单

五条链路的行号断言共 24 处，全部核实：

| 链路 | 结果 |
|---|---|
| 链路 A 发现启动 | ✅ init.dart:190 IsolateSetupAction（报告写 191，偏 1 行）；child/main.dart:48、:77 精确；discovery.dart startListener :37（报告 :35，指向 doc 注释区） |
| 链路 B 重绑 | ✅ 全部命中。B-1 两分支（discovery.dart:125-135）属实；B-2 `_listening` 实际在 :28（报告 :30）；B-3 `_restartRequested` 与 1 秒退避（:110-120）属实；B-4 `RUNNING_DISCOVERY` 实际在 api/discovery.rs:**144**（报告 :141，偏 3 行），"清理热重启遗留实例"的语义与 :185-190 实现一致 |
| 链路 C IP 排序→兜底扫描 | ✅ 全链路（local_ip_provider.dart:82/101/104-105/109 → scan_facade → nearby_devices_provider.dart:217-227 → actions.dart:80/106 → discovery_isolate.dart:138 → discover_staged → 已知通道探测 + grace 1s + scan_subnet）逐步命中；C-1（rankIpAddresses 是顶层函数且被 network_info_provider_test.dart:5-19 直接测试、`'222.1'` 排最后断言在 :7）精确 |
| 链路 D 设置同步 | ✅ init.dart:170-186 构造一次 + actions_sync.dart `_PublishSyncStateAction` 随消息下发 + discovery.dart:60 读取，全部属实。**但见第四节：D-1 把现存 bug 误分类为未来风险** |
| 链路 E 设备确认→传输 | ✅ rust.dart:137 `toDevice()`、send_provider.dart:263/:733 `target.ip!` 精确命中；RegisterDeviceAction 在 nearby_devices_provider.dart:77 |

**E.2 十二处陷阱清单**：12/12 属实，这是报告最硬核的部分。#4/#5 的"不可反驳 let"（api/discovery.rs:441 `let DeviceChannel::Http(http) = log.channel;`、:464 同型）经静态分析确认：单变体 enum 使该模式当前不可反驳，新增变体后立即变成可反驳模式，Rust 必报 E0005（"irrefutable let pattern" 编译错误），且这两处都是**非 pub 内部函数，编译器不会提醒你改**。#7/#8 运行时崩溃路径成立。**但清单不完整，漏了第 13 处**：

> **#13（报告遗漏）**：`app/lib/provider/network/nearby_devices_provider.dart:87`
> ```dart
> assert(device.ip?.isNotEmpty ?? false, 'IP must not be empty');
> ```
> `RegisterDeviceAction` 在设备进入列表时直接断言 IP 非空。蓝牙设备 `ip == null` 时 debug 模式立即抛 AssertionError——比 send_provider.dart:263 的 `target.ip!` 更早触发。release 模式 assert 被剥离后才会轮到 `target.ip!` 崩溃。**E.2 声称 #12 `device_list_tile.dart:64` 是"唯一已就绪的地方"也因此不成立**：`DiscoveryService.addDevice`（discovery.dart:214-222）同样对 `ip == null` 做了优雅降级（跳过并记日志），"唯一"是过度声明。

### Part F 回归风险清单

| # | 报告断言 | 核实结果 |
|---|---|---|
| F-1 | `network_info_provider_test.dart` 直接测 rankIpAddresses、含 `'222.1'` 排最后断言 | ✅ :5-19，断言在 :7，改排序必红，属实 |
| F-2 | `network_interfaces_test.dart` 白/黑名单 | ✅ 文件存在（`app/test/unit/util/network_interfaces_test.dart`） |
| F-3 | core 侧 5 个测试文件 | ✅ discovery.rs / multicast.rs / event_backpressure.rs / accept_resilience.rs / v2_tls_pinning.rs 全部存在于 `packages/core/tests/` |
| F-4 | `event_backpressure.rs` CHANNEL_CAPACITY = 16、验证事件不阻塞 | 🟡 常量实际在 :27（报告 :29），doc 注释 :26 "The capacity the isolate layer uses for both event channels"；两个测试 `register_keeps_answering_when_events_are_not_consumed` / `subnet_scan_finishes_when_events_are_not_consumed` 与"事件发射不阻塞"描述吻合 |
| F-5 | `MULTICAST_CHANNEL_SIZE = 64`（discovery/mod.rs:29） | ✅ 精确 |
| F-6 | "改 socket 绑定必跑 multicast.rs" | 🟡 方向对，但报告不知道一个关键盲区：**tests/discovery.rs 开头明言组播测试在环境不支持时会 skip 而非 fail**（"these tests skip themselves instead of failing when the environment does not cooperate"）。CI 无真实组播环境时这些"必跑"测试会静默跳过——改坏 socket 绑定，CI 可能全绿。报告把测试当作安全网，却没检查安全网本身有没有洞 |

### 引用体系问题（跨 Part）

1. **路径书写不规范且有两处歧义**：`api/discovery.rs` 从未写全路径，真实位置是 `packages/localsend_isolates/rust/src/api/discovery.rs`——不在 `packages/core` 里。报告 Part E/F 的语境会让读者以为它在 core crate。`multicast/mod.rs`、`multicast/socket.rs` 同样未写全路径（真实：`packages/core/src/multicast/`）。对一份以"调用链全景"为卖点的报告，路径模糊是硬伤。
2. **[citation:N] 体系不可解析**：正文出现 citation:1/4/5/6/8/9/10/12/13/14/16/19/20/21 共 14 个编号，"参考出处"一节只做了松散的成组映射，且出现 `[citation:4-旧]`（C.1）这种无法对应到任何编号的写法。外部数据（87% 信道占用、40% 重传、747 vs 506 Mbps 等）全部无法追溯。
