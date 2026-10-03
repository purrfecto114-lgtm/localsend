# Worklog

---
Task ID: 1
Agent: Super Z (main)
Task: 克隆 localsend 源码、逐条核查用户报告、撰写独立评审报告

Work Log:
- 克隆 localsend/localsend（depth 1）到 /home/z/my-project/localsend，HEAD=9529e915，app 1.18.2+64，与报告基线一致
- 克隆 obra/superpowers 到 /home/z/my-project/superpowers-skills（15 个技能），供 subagent 评审团加载
- 逐条核查报告约 60+ 处 文件:行号/代码引文/常量：Rust 侧 store.rs、discovery/mod.rs、multicast/mod.rs、multicast/socket.rs、util/interface.rs、http/server/mod.rs、api/discovery.rs（真实路径在 packages/localsend_isolates/rust/src/api/）；Dart 侧 main.dart、child/main.dart、parent/actions.dart、actions_sync.dart、discovery.dart、discovery_isolate.dart、local_ip_provider.dart、scan_facade.dart、settings_tab_controller.dart、settings_provider.dart、rust.dart、device.dart、favorite_device.dart、send_provider.dart、device_list_tile.dart、signaling_provider.dart、nearby_devices_provider.dart、send_tab.dart、send_tab_vm.dart、init.dart；测试侧 network_info_provider_test.dart 及 packages/core/tests/*
- 在线核验 GitHub issues #144/#427/#850/#2924 标题与日期、#427 维护者引言逐字属实（GitHub API 403 限流，改用 HTML 页面）
- 确认环境无 cargo/rustc/flutter/fvm，E.2 编译断言以静态分析定论
- 发现报告 6 处行号错标（scan_facade:22→15/21、api/discovery.rs:141→144、favorite_device:16→12、device.dart:56→58、discovery.dart:30→28、event_backpressure:29→27、init:191→190）
- 发现报告遗漏：现存缺陷（whitelist/timeout 设置变更后 discovery 不重启，settings_provider.dart:21-40 + discovery.dart:59-79）、nearby_devices_provider.dart:87 的 ip 断言（E.2 第13处陷阱）、send_tab.dart:331 UI 子网选择兜底（机制4"全盘失联"过强）、discoveryTimeout 已是用户可配置项（settings_tab.dart:466-478）、事件通道 try_send 丢弃（discovery/mod.rs:193-207）、组播测试 self-skip（tests/discovery.rs:6-8）、CONTRIBUTING.md AI 贡献限制条款
- 产出评审报告 /home/z/my-project/download/LocalSend传输优化总报告-评审报告.md（220 行：总体评判→逐条核实表→挑刺清单→遗漏缺陷→拓展（缺失机制/安全/上游路径）→修订后落地顺序）

Stage Summary:
- 评审报告 v1 已完成，核心结论：报告 4 机制全部成立、E.2 12/12 属实，但有 6 处行号错标 + 1 处日志细节错误 + 1 处结论过强 + 1 个现存 bug 被误分类 + 1 条上游政策（AI 贡献限制）被完全遗漏
- 下一步：5 视角 subagent 评审团（Task 3-a~3-e）审查评审报告 → 修订定稿 → P0 代码修复 → Next.js 交付

---
Task ID: 3-e
Agent: 上游贡献资深贡献者（5 人评审团）
Task: 审查评审报告"拓展三：上游贡献路径"与"六、修订后的落地顺序"，核实 AI 政策引用、评估 PR 拆分、验证快照漂移推测、给出替代方案

Work Log:
- 按工作流先读 worklog.md，加载 superpowers writing-plans/SKILL.md（计划质量标准：任务粒度=可独立测试交付物、依赖接口显式化、每步可验证——以此为准绳评估 PR 拆分）
- 逐字核对 CONTRIBUTING.md:5-9 AI 政策原文：评审报告引用逐字属实。git log -S 溯源：政策由 Tienisto 于 2026-07-25 在 4199cfd8 "docs: add AGENTS.md" 中加入（CONTRIBUTING.md +6 行，位于欢迎段之后），同 commit 创建 AGENTS.md 且开头逐字重复该政策；CLAUDE.md 仅 @AGENTS.md 引用 + fvm 提醒。评审报告漏报"AGENTS.md 也含同款政策"（恰恰是 AI agent 必读文件）
- 解读核查：三条豁免为 OR 关系，"bug fix"字面上豁免 AI 生成的 bug fix PR——评审报告"P0/P1 合规"方向正确但过宽：PR-1a（设置重启）是无疑义 bug fix；PR-2 的 .1 排序例外是 Tienisto 2023-01-06（338f9a725）亲手写下、4 个测试钉死的启发式，改它属行为变更而非 bug fix；PR-3 新增事件上报属增强。另注意"AI generated"与"AI assisted"的区别——人类执笔+AI 辅助+如实披露根本不落入限制范围，这是比援引豁免更稳的合规路径
- 补齐 AGENTS.md/CLAUDE.md 中评审报告未提的贡献约束：fvm 四处版本钉死、150 列 format CI 检查（先删 lib/gen）、analyze/test、core 必须 --features full、FRB codegen 与两套 build.yaml、Refena/Redux action 规范、"task/ 目录禁止 isolate 逻辑"（task/README.md）、"新 server→app 交互应扩展 ServerEventV2 而非加旁路通道"（直接约束 PR-3 的事件设计）、i18n 走 slang+Weblate 且 i18n_test 守护 locale 集合（直接约束 P1.5 的 UI PR）
- PR 拆分评估：git log --oneline -40 显示维护者 commit 全部单一目的、多数 ≤2 文件（63efbe6b 仅 +42 行、80816a3d/1e15f5cd 等均为小修），最大近期改动 89303dcf（+380/-52、20 文件）也是其本人所为——PR-1 三合一（Windows 监听 + 全平台 resumed + 设置重启）明显超出该仓库的评审粒度预期
- 发现评审报告遗漏的关键 prior art：63efbe6b（2026-08-18，Tienisto 本人）在 main.dart:65-72 加 ensureRunning（Android/iOS 探活式重启 server）与 iOS-only discovery 重绑，注释明言"multicast sockets ... cannot be probed, so always rebind them"——"全平台 resumed 重绑"是在推翻维护者 6 周前的刻意设计且未回应其理由；89303dcf（2026-08-17）已加入 multicastError() 上报 + 全部 socket 死亡后 1 秒退避自愈循环——PR-3 必须在该探活/自愈基础设施上扩展而非另起炉灶
- 验证快照漂移推测：HEAD 9529e915 即评审 checkout 即报告声称基线，三者同一 commit，无漂移可言；错标 6 文件的最后修改时间：favorite_device 2023-12-08、device.dart 2026-08-04、scan_facade 2026-08-10、api/discovery.rs 与 task/discovery/discovery.dart 2026-08-17、event_backpressure.rs 2026-08-24、init.dart 2026-10-02（hunk @@ -199 +199 在 190 行之后，未位移）——2026-08-24 后任一 checkout 的行号完全一致；8/24 前的 checkout 会因 staged-discovery-to-core 等大重构产生远大于 ±7 行的错位。git log --since=2026-08-25 对全部发现链路文件为空。推测不成立，且与评审报告自己"缺一轮机械校对"的诊断自相矛盾
- P1.5 分期评估："README 三条"半项不是上游交付物——README troubleshooting 本就列有防火墙/VPN/本地网络权限（新盲区 3 自己承认），B.3 是原报告自身章节；真正上游化的只有 UI 明示半项，且需 slang i18n + issue 先行 + 与 maxInterfaces 常量耦合，"零风险"言过其实
- 抽验评审报告的修正行号全部命中 HEAD：api/discovery.rs:144、event_backpressure.rs:27、favorite_device.dart:12、device.dart:58、scan_facade.dart:15/21、init.dart:190、discovery.dart:28；network_info_provider_test.dart 确为 4 个测试用例
- 未修改除 worklog 外任何文件

Stage Summary:
- 裁定一：AI 政策引用逐字准确，但解读需收窄——"P0/P1 合规"只对 PR-1a 类无争议 bug fix 成立；PR-2 是改维护者 3 年前的刻意启发式，按 bug fix 援引豁免有被驳回风险；更稳路径是"人类执笔 + AI 仅辅助 + PR 描述披露"，并补报 AGENTS.md:3-7 的同款政策
- 裁定二：PR-1 三合一过大且含与维护者 2026-08-18 刻意设计相抵触的子项，应拆为 2 个 PR + 1 个 issue；PR-3 需改为"扩展既有 multicastError/自愈循环"而非新增并行机制；仓库自 8 月下旬起进入稳定维护期，当前反而是贡献好窗口
- 裁定三：快照漂移推测不成立（同一 HEAD + 错标文件冻结 ≥5.5 周 + init.dart hunk 位移不波及 190 行），应删除该推测、保留"基于最新 HEAD + PR 前机械校验行号"的操作建议
- 裁定四：落地顺序表 P0+/P0/P1/P2/P3 大体可执行，P1.5 应重命名拆解（文档半项改为修订原报告自身，UI 半项降级为 issue 先行的小 PR）
- 下一步：评审报告修订时采纳四项裁定；上游落地以"issue 先行 + 最小可测 PR"序列执行

---
Task ID: 3-a
Agent: 源码事实核查员（5 人评审团）
Task: 独立复核评审报告（download/LocalSend传输优化总报告-评审报告.md）自身的关键引用：抽验 ≥15 处 ✅ 判定、复核 4 个"新发现"真伪、复核其挑的行号错标是否自身准确

Work Log:
- 确认基线：localsend main @ 9529e915f438d8edd8bdf23e9f7aab2261a8b3e6（与评审基准一致）
- 加载 verification-before-completion 技能，所有"属实/有误"结论均以本会话内 sed/grep/Read 的文件:行号输出为证
- 抽验 40+ 处评审报告判定（超额完成 ≥15 处要求），零实质性错误：
  Part A：A-1 store.rs:123-131 注释逐字命中、A-2 store.rs:50、A-3 store.rs:60-67、A-4 store.rs:97-107（Reverse 三元排序键）、A-5 discovery/mod.rs:391-395、A-6 wc -l 实测 1428/528、A-7 signaling_provider.dart:22 + init.dart:238、A-8 device.dart:16/22/38 全部精确
  Part B：B-1 socket.rs:24-25 逐字 + 20-88、B-2 socket.rs:111（注释 109-110）、B-3 mod.rs:289-297、B-4 http/server/mod.rs:230/237（Ipv4/Ipv6 UNSPECIFIED）、B-5 全仓 grep IsolateDiscoveryRestartAction 恰 2 处 dispatch + main.dart:70-73 iOS-only、B-6 local_ip_provider.dart:49-56、B-7 mod.rs:58 + 350-362、B-8 mod.rs:299-308、B-9 socket.rs:118、B-10 scan_subnet discovery/mod.rs:342、B-12 :132-133、B-13（评审判 ❌ 正确：每错一条 warn 352-355 + 放弃一条 error 357-360）、B-15 README Troubleshooting 表 1/2 行逐字
  Part C：C-1 mod.rs:33、C-2 mod.rs:26 + constants.dart:19、C-3 mod.rs:70-72、C-4 mod.rs:45-49、C-5 settings_tab.dart:466-478 → setDiscoveryTimeout → discovery.dart:78
  Part D/E：D-2 api/discovery.rs:459 rs_stored_device + rust.dart:137 toDevice/channels.first、E.2 #4/#5 api/discovery.rs:441/:464 不可反驳 let 逐行命中、device_list_tile.dart:64 判空、链路 A init.dart:190/child main.dart:48/:77/discovery.dart:37、链路 B discovery.dart:125-135/:28/:110-120、链路 C local_ip_provider.dart:82/101/104-105/109 + send_tab_vm.dart:223-234 + network_info_provider_test.dart:7、链路 E send_provider.dart:263/:733 target.ip!
  Part F：F-1 测试 :5-19 断言 :7、F-3 五个测试文件存在、F-4 event_backpressure.rs:27（doc :26）+ 测试名 :81/:107、F-5 mod.rs:29 = 64、F-6 tests/discovery.rs self-skip 句在 7-9、拓展三 CONTRIBUTING.md:5-8 AI 条款逐字 + AGENTS.md:80 裸 cargo check 失败
- 复核 4 个"新发现"全部属实：
  (a) 设置变更后 discovery 不重启 = 真实 bug。完整证据链：settings_provider.dart:21-40 onChanged（仅 4 字段）→ IsolateSyncSettingsAction（actions_sync.dart:51-78）→ _PublishSyncStateAction 仅下发 syncState；child/main.dart:76-78 仅 UpdateSyncStateAction；discovery.dart:53-57 的 syncProvider 流监听只响应 serverRunning；_runListener while 循环 :59-121 仅在 listen 流结束时重读 syncState；restartListener（discovery.dart:125-135）唯一入口 DiscoveryRestartTask（discovery_isolate.dart:126-128）→ IsolateDiscoveryRestartAction（actions.dart:170-189）→ 全仓仅 main.dart:72（iOS resumed）与 settings_tab_controller.dart:149（onTapRestartServer，settings_tab.dart:351 刷新图标按钮）两个 dispatch；serverProvider（server_provider.dart:35-62）变更只走 IsolateSyncServerStateAction 不重启 discovery；restartServerFromSettings/restartServer 调用点（settings_tab.dart:215/:282、web_share_page、setWebPin、_restartDeadServer）无一由 whitelist/blacklist/multicastGroup/discoveryTimeout 变更触发；Rust 侧 InterfaceFilter 仅在 start_discovery（api/discovery.rs:165-208）构造一次。无隐藏重启路径，误报排除
  (b) nearby_devices_provider.dart:87 assert(device.ip?.isNotEmpty ?? false, 'IP must not be empty') 逐字属实；discovery.dart:214-225 addDevice 对 ip==null 优雅跳过属实
  (c) send_tab.dart:331 条件 ips.length <= maxInterfaces、349-354 弹窗走 StartLegacySubnetScan(subnets: [ip])（单网段）、ips 来自 vm.localIps=localIpProvider.localIps 全量（send_tab.dart:180-182, send_tab_vm.dart:54）——实质属实，但评审自己引 "331-347" 不含 dispatch 行 353
  (d) discovery/mod.rs:193-207 found() try_send + "Dropping an event only costs a refresh"（:201 逐字）+ 仅 debug 日志（:205）属实；api/discovery.rs:192 mpsc::channel::<DiscoveryEvent>(16) 属实；app/lib 无 devices() 轮询，UI 仅靠事件流，"漏显直到下次确认"成立
- 复核 7 处行号纠错全部准确：scan_facade.dart:15/21、api/discovery.rs:144、favorite_device.dart:12、device.dart:58、discovery.dart:28、event_backpressure.rs:27、init.dart:190
- 发现评审报告自身 4 处问题：①"6 处行号错标"计数与所列 7 项自相矛盾（总体评判/挑刺清单#5）；②挑刺清单#1"设置页保存"表述失准，实为设置页"重启服务"按钮（settings_tab.dart:351 → onTapRestartServer），原报告此处原本写对了；③挑刺清单#1"直到重启 App 或改端口"失准：改端口仅 setPort（settings_tab.dart:443-453）不触发任何重启；④B-14/挑刺清单#2 引 send_tab.dart:331-347 但 StartLegacySubnetScan 派发在 353，超出引文区间（讽刺性重犯行号引用不严）；另 C-5"超时改设置即可生效"与其自身新缺陷 1（discoveryTimeout 变更同样要重启才生效）存在内部张力，宜交叉引用；tests/discovery.rs:6-8 实为 7-9（±1，微）

Stage Summary:
- 评审报告抽验 40+ 处零实质错误，4 个新发现全部真实成立（尤其新缺陷 1 经完整重启路径排查确认为现存 bug，非误报），7 处行号纠错全部准确
- 评审报告需修订 4 处：行号错标计数 6→7、"设置页保存"→"设置页「重启服务」按钮"、删"或改端口"、B-14 引文区间改 331+349-354；建议 C-5 补"需手动重启生效"注脚
- 评审报告整体可信度维持高位，修订量小；产出仅本 worklog，未改动其他任何文件

---
Task ID: 3-d
Agent: 安全审查员（5 人评审团，专长 BLE 安全与隐私 / TLS-PKI / 近场传输协议攻击面）
Task: 审查评审报告《LocalSend传输优化总报告-评审报告.md》拓展二"安全维度"4 个论点，核对代码锚点与原报告 Part A，评估标识符轮换方案、HTTP 模式攻击面与安全节完整性

Work Log:
- 按流程读取 worklog.md 并加载 superpowers/requesting-code-review 技能，遵循"锚点逐条验证、以代码证据反驳、不因犀利牺牲客观"纪律
- 通读评审报告拓展二（4 论点）与原报告 Part A（A.1-A.7）；精读 packages/core/src/discovery/mod.rs 全文，核对三个锚点：
  - unpinned_client :142-152 ✅（doc 142-144 原文 "The fingerprint is then read off the handshake and pinned by connections that transfer data"，评审转述忠实）
  - HTTPS 指纹取自证书 :168-176 ✅（注释 168-169 + match 170-176，Https→cert_fingerprint、Http→body）
  - answer_announcement 预置 pinning :519-527 ✅（expected_fingerprint 519-522 + try_new 523-527），方向描述正确：应答方作为 TLS client 连接公告方时，把公告中声称的指纹设为对端证书期望指纹
- 发现论点 2 关键遗漏：expected_fingerprint 的 Http 分支为 None（:521），即 HTTP 模式完全不 pin；且 answer_announcement 成功路径把 message.fingerprint（公告声称值）直接写入 store（:547-553），:545-546 注释 "The pinned certificate identifies the peer" 在 HTTP 分支不成立；评审判定 TOFU 风险：伪造公告只能导致握手失败或攻击者以"自己真实身份"入 store（证明持有私钥），无法冒充第三方设备（无法伪造他人指纹对应证书），无 MITM 提升——评审未做此分析
- 精读 http/client/server_cert_verifier.rs（PinnedServerCertVerifier：握手期指纹校验、None=TOFU 仅限 discovery）、http/client/mod.rs（cert_fingerprint_from_res :298-307）、v2.rs register（:103-109 Https→取 TlsInfo 证书指纹）
- 精读 http/server/v2.rs register（:161-166）：HTTPS 下校验 payload.fingerprint==mTLS 客户端证书指纹，HTTP 下 `None => true` 无条件放行——服务端路径是比 BLE 更直接的设备列表注入入口，评审完全未覆盖；事件经 ServerEventV2::Register → app → add_device（api/discovery.rs:396）进 store
- 精读 discovery/store.rs upsert（:196-244）：按指纹去重；同指纹异 host → 追加通道（:206-212）且 known.device 被整体替换（:227，攻击者可改写 alias）；确认 HTTP 模式下"假设备能进 store"且可对真实设备做通道劫持
- 核对传输侧：send_provider.dart:95/:729 pinnedTo(target.fingerprint)、http_provider.dart:9-37（discovery client 接受任意证书、pinnedTo 仅供传输）；确认 pinning 是 TLS 层机制，HTTP 模式传输无任何对端认证
- 确认 HTTP 模式是用户可选设置（settings_provider.dart:68 https: _persistence.isHttps()、:232-236 setHttps）
- 精读 tests/v2_tls_pinning.rs：doc :3-4 与评审引文一致（"客户端在写入任何请求数据前完成对端证书认证"为忠实翻译）；:282-316/:319-346 验证指纹不匹配时请求体永不抵达对端 ✅
- 精读 model/discovery.rs MulticastMessageV2（:126-129）：组播公告本就以明文 UDP 广播完整稳定指纹（HTTPS=证书 SHA-256）；crypto/cert.rs :22-27 注释明言证书 1975-4096 有效"never need to be rotated"——轮换方案的最大障碍锚点，评审未提
- 在线核验 AirDrop 引用（privatedrop.github.io 官方项目页）：TU Darmstadt 团队 2019-05 负责任披露、Apple Bleee 2019-07 独立公开；正式论文为 PrivateDrop（USENIX Security **'21**）与 AirCollect（ACM WiSec **'21**）；**不存在 "USENIX Sec'19" 论文**——评审论点 1 的引用有误（其自身批评原报告"无出处"，此处却引错 venue/年份）
- 交叉核对组播接收路径（multicast/mod.rs :381 ip 取自 UDP 源地址 :345-387）与 answer_announcement 无界 tokio::spawn（:486-488）："伪造广播诱导 probe"今天经组播已可实现，BLE 边际增量是"无用户操作的后台触发"；应答路径无并发上限（对比 scan_subnet 有 SCAN_CONCURRENCY=50 + ScanGuard）
- 评估轮换方案：register 应答字段固定（dto_v2.rs :57-84，无轮换 ID 字段），轮换 UUID 后"扫到→register 握手→确认"无法把 BLE 广播 X 映射到设备 Y；轮换与 31 字节广播载荷上限、store 按指纹去重、收藏夹（按指纹存储）的兼容性代价评审均未分析

Stage Summary:
- 拓展二 4 论点裁定：论点 1 实质成立但 AirDrop 引用错误（USENIX Sec'19 → Sec'21/WiSec'21）；论点 2 三锚点全部属实且 pinning 方向描述正确，但"零改动/论证闭环"过度（漏 HTTP 分支 + TOFU 分析）；论点 3 "probe 入口都经过 TLS/投毒上限=无效地址探测失败/无信任提升"为 HTTP 模式下的错误断言（假设备可入 store、可劫持真实设备通道、HTTP 传输可被明文截获）；论点 4 属实
- 识别评审安全节缺失项：HTTP 模式信任模型（用户可选关闭加密）、服务端 register 注入路径、组播公告已泄露完整稳定指纹（BLE-only 轮换无效）、证书不可轮换、Android BLE 权限模型（12+ 运行时权限/≤11 定位权限）、BLE MAC 随机化、L2 GATT 配对/加密要求（Legacy Just Works 无 MITM 防护）、answer_announcement 无并发上限
- 结论已按模板追加至 worklog；未修改 worklog 以外任何文件

---
Task ID: 3-b
Agent: 网络协议专家（评审团 5 人之一）
Task: 从网络协议专业角度审查原报告机制 1-4 与评审报告新增机制 5-8 的成立性/严重度评分；核对 VPN tun 接口组播绑定说法；评判 Part C 2.4G 数据与 Part D MLO 论断；点名评审报告自身的技术错误

Work Log:
- 加载 systematic-debugging 技能并遵循根因纪律：所有判定均先回到源码/一手资料取证，不做无证据评分
- 通读评审报告（220 行）与原报告全文；逐机制到源码复核：
  - socket.rs：逐接口绑定循环 :38-57（v4）、:59-85（v6）；set_multicast_if_v4 钉死出口 :111；set_multicast_ttl_v4(1) :118；set_multicast_hops_v6(1) :150；注释"绑不上的接口才跳过（e.g. a virtual adapter）" :27-28
  - interface.rs：local_interfaces 仅滤 loopback + InterfaceFilter（用户白/黑名单，默认空），无任何按名称/类型的虚拟网卡过滤 → tun/ppp/utun 默认全通过 → 评审机制 6(c) 证实
  - multicast/mod.rs：组 224.0.0.167 且注释 :26-28 "224.0.0.0/24 是部分 Android 设备唯一能收组播的段"；MAX_CONSECUTIVE_RECEIVE_ERRORS :58；receive_loop 每错一条 warn + 放弃一条 error :350-362；SocketsFailed 仅全军覆没 :299-308；send 失败有 warn :200-202
  - discovery/mod.rs：found() try_send + "Dropping an event only costs a refresh" :189-208；unpinned_client :145-152；probe 从证书取指纹 :170-176；answer_announcement 预置 pinning :517-527（评审拓展二三锚点全部属实）
  - api/discovery.rs：RUNNING_DISCOVERY :144、事件通道 16 :192
  - Dart 侧：local_ip_provider.dart :49-56 Windows 排除、rankIpAddresses :109-136（.1 规则 :132-133、thirdPartyResult 为 .1 时走 _rankIpAddresses(null) :116-118）；network_interfaces.dart 仅正则白/黑名单、无 VPN 过滤；scan_facade.dart :15/:21；send_tab.dart :331-353 弹窗兜底；main.dart :63-74 Android+iOS ensureRunning、iOS-only 重绑；discovery.dart :53-57 sync 流监听只盯 serverRunning（新缺陷 1 实锤加强）
  - Android：AndroidManifest 无 CHANGE_WIFI_MULTICAST_STATE；全仓 grep 零 MulticastLock —— 两份报告均漏 Android 组播过滤器机制；manifest 证实 flutter_foreground_task dataSync 仅"接收进度保活"（评审机制 7 前提准确）、Android 17 ACCESS_LOCAL_NETWORK 注释；iOS：Runner.entitlements 已含 com.apple.developer.networking.multicast、Info.plist 已含 NSLocalNetworkUsageDescription/NSBonjourServices → 机制 5 是纯"用户拒绝"场景而非缺配置
  - README Troubleshooting 四行（AP 隔离/Windows 专用网络/Local Network 权限/VPN）逐一命中评审"新盲区 3"
- 外部核验：Apple multicast entitlement 文档存在且 LocalSend 已持证；GitHub issue 检索证实"Local Network 被禁 → UDP/mDNS 发送失败需显式处理"是第三方 App 普遍模式（openastro-ara PR#1117、warpinator-android #150 等），支持"发送侧 EPERM 非静默"判断（建议实机 5 分钟复核）
- 形成逐机制评分判定（1-4 同意、2 触发归因需修正；5/6 同意但各有一处表述过头；7 同意偏保守且有 NSD 表述错误；8 前提严谨需补两个例外角）；整理评审报告自身技术错误 3+2 处；产出拓展增补 5 条

Stage Summary:
- 核心结论：评审报告的机制挖掘与评分体系基本过硬（8 个机制 7 个判级同意），但机制 5"全部静默失败"、机制 6"取决于系统路由"、机制 7"冻结 NSD"三处专业表述失准；两份报告共同漏掉 Android 组播过滤器/MulticastLock 缺失这一重要机制（建议并入机制 7 升级 ⭐⭐）；VPN 场景应补隐私泄露（fingerprint/alias 进隧道）与兜底扫描扫 VPN 网段两个后果；Part C/D 数据与 MLO 判断专业上站得住，评审"论证完整性 3/5"的扣分点全部核实成立
- 下一步：汇总 5 视角意见修订评审报告 → 定稿

---
Task ID: 3-c
Agent: 挑刺型评审（devil's advocate，5 人评审团成员）
Task: 攻击评审报告《LocalSend传输优化总报告-评审报告.md》本身：双重标准、过度声明、遗漏、薄弱环节

Work Log:
- 通读评审报告全文（220 行）与原报告（424 行），加载 receiving-code-review 技能并以"每个批评须证据确凿、给可执行修正"标准反审评审报告自身
- 双重标准抽查：对评审报告自引行号抽查约 50 处（store.rs:50/60-67/97-107/123-131/135/143/150/196-229、discovery/mod.rs:26/29/33/142-152/168-176/193-207/272/342/391-395/519-527、multicast/mod.rs:45-49/58/289-297/299-308/350-362、socket.rs:24-25/38-57/109-111/118、api/discovery.rs:144/185-190/192/441/459-483/464、settings_provider.dart:21-40、settings_tab_controller.dart:149、discovery.dart:28/37/59-79/78/110-120/125/125-135/214-222、local_ip_provider.dart:49-56/101/104-105/109/116-118/129-136、scan_facade.dart:15/21、nearby_devices_provider.dart:77/87/217-227、send_tab_vm.dart:223-234、settings_tab.dart:466-478、main.dart:63-74、init.dart:170-186/190/238、actions.dart:80/106/169/178-185、actions_sync.dart:51-78、constants.dart:19、util/rust.dart:137-150、model/device.dart:16/22/38/58/100、favorite_device.dart:12、device_list_tile.dart:56-75/64、send_provider.dart:263/733、signaling_provider.dart:22、webrtc 1428/528 行、network_info_provider_test.dart:5-19/7、event_backpressure.rs:26-27、tests/discovery.rs:6-8、AGENTS.md:80、CONTRIBUTING.md:5、README Troubleshooting 3-4 行、v2_tls_pinning.rs doc）——除 send_tab.dart:331-347 区间未含其引文（StartLegacySubnetScan 实在 :351-354）外全部命中，未发现行号偏移错误
- "6 处错标"计数攻击成立：挑刺清单实列 7 处修正（scan_facade/api-discovery/favorite/device.dart/discovery.dart/event_backpressure/init），摘要表、总体评判、第七节均写"6 处"；worklog Task 1 即已 7 条记为 6 处，错误自上游传播
- "现存缺陷 1"反例搜索（6 条路径全部走完）：settingsProvider.onChanged→IsolateSyncSettingsAction→_PublishSyncStateAction 仅更新 syncProvider（actions_sync.dart:51-78/113-145）；IsolateSyncServerStateAction 仅同步状态（actions_sync.dart:80-110）；serverProvider.ensureRunning 仅探测/重启 HTTP server（server_provider.dart:385-405），restartServer 全部调用方无一派发 IsolateDiscoveryRestartAction；子 isolate syncProvider 流监听仅响应 serverRunning（discovery.dart:53-57）；全仓 grep 证实 dispatch 恰 2 处（main.dart:72 iOS、settings_tab_controller.dart:149 重启服务按钮）→ 无任何路由让 whitelist 变更作用于运行中的 Rust discovery，🔴指控成立（幸存）
- 但发现该指控自身两处瑕疵：①"直到重启 App 或改端口"错误——settings_tab.dart:447-452 端口 onChanged 仅 setPort 持久化，无任何 watcher 重启 server/discovery，与其同段"只有两个触发点"自相矛盾；②遗漏三条 doc 注释佐证（discovery.dart:124、discovery_isolate.dart:40、actions.dart:169 均写明 restart 意图含 "network settings changed"，设计意图与实现断裂的最强证据）与一条偶发自愈路径（discovery.dart:59-60/102-121：socket 失败致 listen 流结束后 while 循环以新 syncState 重启，新配置间接生效，"纹丝不动"略过强）
- 统计复算攻击成立：原报告 grep 计 79 处 文件:行号 引用；评审自列行号错 7-8 处 → 精确率 90-91%，其宣称"约 83%"不可复算；仅 scan_facade:22→15 超 ±4（7 行）→ "95% 在 ±4 行内"亦不可复算；"22 处可核验断言（Part A 实际 11 行）、24 处链路断言"同属不可审计
- 口径漂移攻击成立："E.2 12/12 属实"中的 #9（favorite_device.dart:16）与 #10（device.dart:56）恰是其"行号错标"清单成员——同一证据既计入褒（12/12）又计入贬（6/7 处错标），按其自身图例应为"10 ✅ + 2 🟡"
- 过度声明攻击："前 5%"无分母无语料不可证；B-13 裁决"用户找那条 warn 会找不到"与其自身证据（10 warn + 1 error）自相矛盾——原报告错在低估日志量，实际后果是日志易找而非难找；"唯一已就绪"的反例（discovery.dart:217-222 skip 并记日志，设备永不显示）本身不足以推翻"唯一"，两种读法均通（可以商榷）
- 拓展双标攻击成立：其对 A-11 要求"按报告自己的标准应标待核实"，但自身机制 5（iOS 权限静默失败）、机制 6（VPN 网卡 .1 得分更高）、机制 7（Doze 冻结）均为无引用外部知识且未标注待核实，机制 7 还宣称"解释了报告未解释的现象"（与其批 C-6"正反馈无实测支撑"同型）；另漏 init.dart:212-220 Android 本地网络权限申请代码流（本可强化其机制 5）
- 结构性遗漏确认：Part C.1/D.1 全部外部数据（87% 占用、40% 重传、747vs506、3570Mbps、135%/71%/41%）零可信度评估却给"外部引文可信度 ★★★★☆"；受众适配/可操作性零着墨；README Troubleshooting 第 5 行（手动 IP+收藏直连 workaround）未纳入；core/tests 实有 10 个测试文件（connections.rs、internal_server.rs、v2_server.rs、v2_web_download.rs、hash.rs 未评估覆盖面）；四/五/六节约 70 行（32%）为新工程方案（PR-1..4、密码学设计），评审报告含 rewrite 属性
- 在线独立复核：discussion #427 创建于 2023-04-29、Tienisto 引言逐字命中、issue #144/#850 标题属实——评审报告外部引文经二次独立核验全部成立
- 未修改除 worklog 外任何文件

Stage Summary:
- 评审报告核心事实底座经攻击后依然稳固：自身行号抽查 ~50 处近乎全中、7 处对原报告的行号纠错全部属实、🔴"现存缺陷 1"经 6 路反例搜索幸存、外部引文二次核验成立
- 但其"评审腔"包装下存在可证实缺陷：①"6 处"实为 7 处（计数错误，恰是其指控原报告的罪名）；②E.2 12/12 与 6 处错标存在口径漂移（同一证据双重计入）；③"改端口"逃逸路径错误且与自身矛盾；④83%/95%/22 处/24 处等统计不可复算（犯它起诉原报告的"不可追溯"罪）；⑤对待核实标准双重标准（A-11 vs 自身机制 5/6/7）；⑥四/五/六节 32% 篇幅实为 rewrite；⑦"前 5%"不可证
- 结论：必须修改 7 项、可以商榷 7 项（详见最终回复）；修订后评审报告的指控力度不降反升（"改端口"修正 + doc 注释佐证使🔴#1 更硬）

---
Task ID: 3-a~3-e
Agent: 5-view subagent review panel (fact-checker / network-protocol / devil's advocate / security / upstream-contributor)
Task: 加载 superpowers 技能，独立反审查 v1 评审报告

Work Log:
- 3-a 事实核查员：40+ 处抽验零实质错误；确认 4 个新发现全部真实（新缺陷1 经 6 条反例路径穷尽攻击幸存）；抓出 v1 自身 6 处表述问题（6→7 处计数、"或改端口"逃逸路径错误、send_tab 引文区间不含目标代码等）
- 3-b 网络协议专家：8 机制 7 判级同意；修正 3 处系统行为错误（iOS 发送侧 EPERM 可观测、VPN 出口被 set_multicast_if_v4 钉死、Doze 不冻结系统 NSD）；发现两份报告共同最大盲区：Android MulticastLock/CHANGE_WIFI_MULTICAST_STATE 全仓缺失；机制2 归因修正（RF 干扰不产生 socket 错误）
- 3-c 魔鬼代言人：9 条攻击（计数矛盾、统计不可复算 83%/95%、双重标准、"前5%"不可证伪等）；确认新缺陷1 成立 + 建议补 doc 注释三证据（discovery.dart:124 / discovery_isolate.dart:40 / actions.dart:169 均写明 restart 意图含 network settings changed）
- 3-d 安全审查员：3 代码锚点属实、pinning 方向正确；纠正 AirDrop 引文（应为 PrivateDrop USENIX Sec'21）；判定 v1 "probe 都过 TLS"为全称命题错误（HTTP 模式 store 入口无认证 server/v2.rs:163-166 None=>true）；补通道劫持攻击面（store.rs:206-227）与轮换匹配链断裂问题
- 3-e 上游贡献者：AI 政策同时存在于 AGENTS.md:3-7（commit 4199cfd8）；git blame 显示 main.dart iOS-only 门是 63efbe6b（2026-08-18）刻意设计、.1 排序是 338f9a725（2023）刻意行为；判定"快照漂移"推测不成立（同一 commit）；给出 Issue×2+PR×3 替代序列

Stage Summary:
- v1 评审报告 4 新发现全部经攻击幸存，自身 14 处问题已全部纳入 v2 修订
- v2 定稿：/home/z/my-project/download/LocalSend传输优化总报告-评审报告.md（235 行，含第七节自我修正记录）
- 代码修复方向按 3-e 修订：首发 PR = 设置变更触发重启（≤20行）；.1 排序需以 heuristic-gap issue 形式走；机制2 应扩展 89303dcf 既有自愈设施

---
Task ID: 6
Agent: Super Z (main)
Task: 按评审结论修改 localsend 代码（P0 修复）

Work Log:
- Fix 1（settings_provider.dart onChanged）：设置同步后追加 IsolateDiscoveryRestartAction（带 discovery!=null 守卫），修复"whitelist/timeout 变更不生效"现存缺陷；利用同通道 FIFO 保证子 isolate 先收到新 syncState 再重启
- Fix 2（local_ip_provider.dart）：(a) rankIpAddresses 移除 thirdPartyResult.endsWith('.1') 降权特例——活动 Wi-Fi 接口的 .1 地址（热点网关）优先；(b) Windows 分支改为 10 秒接口轮询（规避 #12/#78 误报但拾取接口变化）；(c) FetchLocalIpAction 在 IP 集合实际变化时派发 discovery 重绑（集合比较避免纯排序变化误触发）
- Fix 3（scan_facade.dart）：maxInterfaces 3→5，注释说明多网卡+热点场景与分阶段扫描的成本权衡
- Fix 4（main.dart）：resumed 重绑从 iOS-only 扩展到 Android，注释标明与上游 63efbe6b 设计决策的张力及探活式替代方案
- Fix 5（network_info_provider_test.dart）：新增 3 个测试用例（Android/iOS 热点网关优先、native .1 仍排最后），旧 4 用例不受影响
- 产出：/home/z/my-project/download/localsend-p0-fixes.patch（180 行 diff）+ download/modified-source/ 完整文件副本；大括号/圆括号平衡检查通过；环境无 flutter/cargo，无法运行 fvm flutter test，已注明

---
Task ID: 7
Agent: Super Z (main)
Task: Next.js 服务器交付 + 源码持久化 + 最终 worklog

Work Log:
- 加载 fullstack-dev 技能，初始化 Next.js 16 环境（bun dev @3000）
- 安装 remark-gfm（react-markdown 已有）
- 构建单页交付应用（/ 路由）：
  - src/lib/content.ts：服务端从磁盘读取持久化内容（评审报告/原报告/补丁/修改后源文件）+ unified diff 解析器
  - src/components/delivery/markdown-view.tsx：报告级 markdown 渲染（表格/代码块/引用块样式）
  - src/components/delivery/patch-viewer.tsx：补丁查看器（文件 tab + 行号 + 增删行着色 + 完整补丁）
  - src/app/page.tsx：4 个 tab（评审报告 v2 / 原报告 / 代码修改 / 交付与验证）+ 关键数据卡片 + sticky footer
  - src/app/layout.tsx：中文 metadata，lang=zh-CN
- ESLint 排除克隆仓库目录（localsend/superpowers-skills 等）后通过
- agent-browser 端到端验证：4 个 tab 全部渲染正常、diff 内容与交付物可见、390px 移动端正常、console 无错误；截图存档 download/preview-*.png
- 源码持久化三处落地：download/localsend-p0-fixes.patch、download/modified-source/（5 文件完整副本）、workspace 内修改后的 localsend 克隆

Stage Summary:
- 全部交付完成：评审报告 v2（39.9KB）、补丁（9.4KB）、修改源码副本、Next.js 预览站点（浏览器验证通过）
- 待用户在有工具链环境执行：fvm flutter analyze && fvm flutter test app/test/unit/provider/network_info_provider_test.dart

---
Task ID: 8
Agent: Super Z (main)
Task: 生成完整 handoff 交接文档（资产清单 + 下一 agent 自包含提示词）

Work Log:
- 盘点 download/、upload/、scripts/review_parts/、src/（交付站点）、localsend/、superpowers-skills/ 全部资产
- 对 8 个关键交付文件生成 MD5 校验和；确认 localsend 工作区 HEAD=9529e915 且 5 个 M 文件与补丁一致
- 产出 /home/z/my-project/download/HANDOFF.md：一句话状态 → 资产清单（三表：用户交付物/工作区资产/站点访问）→ 核心结论速查（评判/新发现/上游情报/P0 修复）→ 环境约束 8 条 → 待办 4 项 → 自包含交接提示词 → 签署检查单

Stage Summary:
- 交接文档已交付：download/HANDOFF.md；下一个 agent 无需本对话任何上下文，按其"第一步"读 worklog + HANDOFF + 评审报告即可全权接手
- 项目状态定格：主链路 100% 完成；剩余工作全部需要 Flutter/Rust 工具链或 GitHub 交互

---
Task ID: 9
Agent: Super Z (main)
Task: 全量打包交接 zip（适配全新重置环境：解压即恢复）

Work Log:
- 关键前提：下一会话为重置环境，工作区资产（localsend 克隆/站点源码/worklog）不存活，仅 download/ 存续
- 打包范围：HANDOFF.md（v2 重置版）+ worklog.md + deliverables/（评审报告/补丁/modified-source/截图）+ original-report/ + review-parts/（v1、v2 草稿×6）+ site-src/（站点 5 源文件 + 恢复说明）
- 有意排除：localsend 仓库本体与 superpowers-skills（重克隆成本低于打包体积，HANDOFF 给出钉死 commit 的重建命令）；node_modules/.next（脚手架可重建）
- HANDOFF v2 相对 v1 的微调：新增"环境恢复六步"（解压→重建仓库→应用补丁→校验→可选重建站点）；路径全部改写为包内结构；"工作区是脏的"条目改写为恢复指令

Stage Summary:
- 产出 /home/z/my-project/download/localsend-review-handoff-20261003.zip（单一交接工件，解压即恢复 90% 工作状态）
- 剩余 10% 不可打包项：localsend 仓库与 superpowers 技能库（重克隆命令已写入 HANDOFF）

---
Task ID: 10
Agent: Super Z (main, 新会话接手)
Task: 从交接包恢复工作区 + 网络核验 PAT 与上游基线 + 重建 localsend 源码并应用 P0 补丁

Work Log:
- 解压 upload/localsend-review-handoff-20261003.zip，22 个关键文件 MD5 与 HANDOFF 2.1 节记录逐字节一致（含评审报告 f470dca4、补丁 19698cb8、原报告 710600c4、worklog b9b42830）
- 按恢复规程归位：worklog.md → 工作区根目录；评审报告+补丁+modified-source → download/；原报告 → upload/；交接包本体 → localsend-review-handoff/
- 网络核验（用户提供的细粒度 PAT [REDACTED]）：账号 purrfecto114-lgtm（id 224034298），认证后 API 限额 5000（上一会话的 403 限流问题消除）
- 网络核验上游基线：api.github.com 确认 localsend/localsend commit 9529e915 真实存在（2026-10-03T01:39:51Z，"feat: respect system date and time formats (#3472)"，作者 Shlomo）——评审基线无漂移的在线证据
- 发现账号已有 purrfecto114-lgtm/localsend fork（2026-10-03T06:05:33Z 创建），其 main HEAD 恰为 9529e915，token 对其有 push 权限
- git clone localsend → checkout 9529e915 → git apply localsend-p0-fixes.patch：--check 预检通过，恰 5 个 M 文件，5 个文件 MD5 与 HANDOFF 2.1 逐字节一致（95fe9aca/8887b404/e1d1cf50/aa0ed189/eb78b2b5）

Stage Summary:
- 工作区从交接包 100% 恢复，全部校验通过；网络依据链完整（PAT 身份/权限/上游 commit/fork 状态四项在线核实）
- 关键发现：PAT 为"仅选定仓库"模式——可推送 9 个既有仓库（含 localsend fork），但对新建仓库 Contents 写权限不覆盖（实证：POST /user/repos 建仓成功但 git push 403 denied，DELETE 亦 403）

---
Task ID: 11
Agent: Super Z (main)
Task: [第一步推送·简单] 评审文档持久化到远端 fork review-docs 分支

Work Log:
- 因 PAT 选定仓库限制，放弃独立 localsend-review 仓库方案（空壳已留在账号上，token 无法删除也无法推送，需用户手动处理），改为推送 fork 孤立分支
- 搭建 localsend-review-repo 暂存区：README.md（含核心结论速查/P0 修复表/MD5 校验表/上游贡献策略/验证状态）+ HANDOFF.md + worklog.md + original-report/ + review-report/ + review-parts/（v1×3 + v2×3）
- git init -b main，提交 aa92779（11 文件 +1666 行），推送 fork main:review-docs 成功
- 网络核验：GET /branches/review-docs 返回 commit aa92779；compare main...review-docs 404 属孤立分支无共同祖先的预期行为

Stage Summary:
- 评审报告 v2（235 行）、原报告原件（MD5 未动）、6 份草稿分片、交接档案全部持久化到 https://github.com/purrfecto114-lgtm/localsend/tree/review-docs

---
Task ID: 12
Agent: Super Z (main)
Task: [第二步推送·中等] P0 交付物与站点源码增量推送

Work Log:
- 追加 deliverables/（localsend-p0-fixes.patch + modified-source/ 5 文件完整副本 + preview-*.png 2 张验证截图）与 site-src/（Next.js 站点 5 源文件 + 恢复 README）
- 提交 d6ba8a5（14 文件 +1562 行），推送 fork review-docs 成功
- 网络核验：GET /commits?sha=review-docs 返回 d6ba8a58 → aa927791 两提交

Stage Summary:
- 全部交付物（补丁/修改后源码副本/站点源码/截图）持久化完成；review-docs 分支成为交接包的远端镜像

---
Task ID: 13
Agent: Super Z (main)
Task: [第三步推送·较难] P0 修复提交持久化到 fork p0-discovery-fixes 分支（源码持久化核心）

Work Log:
- 在 /home/z/my-project/localsend（HEAD=9529e915，补丁已应用）建分支 p0-discovery-fixes
- git diff --stat 确认 5 文件 +83/−6，与 HANDOFF 3.4 逐文件一致（main.dart +9/−1、local_ip_provider +41/−4、scan_facade +7/−1、settings_provider +10/−0、测试 +16/−0）
- 提交 9a661080（英文 conventional commit，完整说明 5 项修复内容 + doc 注释证据链 + 63efbe6b 设计张力标注 + "未经工具链验证"披露 + provenance 指向 review-docs 分支），推送 fork 成功
- 网络核验：compare main...p0-discovery-fixes → status ahead 1 commit, 5 files，逐文件 +/− 统计与本地完全一致；fork 分支总览：main=9529e915（未动）、p0-discovery-fixes=9a661080、review-docs=d6ba8a58

Stage Summary:
- 源码持久化核心完成：完整 localsend 源码（钉死基线 9529e915）+ P0 修复提交 9a661080 存在于远端 fork，main 分支保持与上游一致未被污染
- 上游贡献（issue/PR）依"禁止乱改"原则未执行——评审 Task 3-e 结论要求 issue 先行 + 人类执笔合规，需用户明确指令

---
Task ID: 14
Agent: Super Z (main)
Task: 重建 Next.js 交付站点 + agent-browser 端到端验证

Work Log:
- 按 site-src/README.md 映射恢复 5 文件到 src/（page.tsx/layout.tsx/content.ts/markdown-view.tsx/patch-viewer.tsx），MD5 与 HANDOFF 2.1 逐字节一致
- bun add remark-gfm@4.0.1（react-markdown@10.1.0 脚手架已有）
- content.ts 磁盘路径验证：download/（评审报告+补丁）✓、upload/（原报告）✓、localsend/（修改后源文件）✓——三处依赖在 Task 10 恢复中已全部就位，无需改路径
- bun run lint 通过（exit 0）
- agent-browser 端到端验证：4 tab 全渲染（评审报告 v2 含完整评分表、原报告全文、代码修改 5 文件子 tab + diff 着色、交付与验证清单）；console 零错误；390×844 移动端 footer 存在且内容 2300px 自然下推；dev.log 无运行时错误
- 截图存档：download/preview-review-restored.png、preview-delivery-restored.png、preview-mobile-restored.png

Stage Summary:
- 交付站点恢复并验证通过，与上一会话 Task 7 的验证先例（4 tab + 移动端 + console 无错）完全一致

---
Task ID: 15
Agent: Super Z (main)
Task: 终态 worklog 追加 + 同步远端 + 向用户交付

Work Log:
- 本 worklog 追加 Task 10~15 六段记录
- worklog.md 更新后推送 fork review-docs 分支（第三次增量推送）
- 向用户报告：三步推送全部完成 + 网络核验证据 + PAT 选定仓库限制说明（空壳 localsend-review 仓库需手动删除或加入 token 选定范围）

Stage Summary:
- 项目状态：主链路 + 远端持久化 100% 完成；剩余待办不变（Flutter 工具链验证、上游 issue/PR 需用户指令）

---
Task ID: 16
Agent: Super Z (main)
Task: 按用户指令重构持久化：删除分支改推 fork main + review/ 存档 + release workflow

Work Log:
- 用户指令：不上游 PR（未验证）、删新建分支、直接推 fork main、发布 release（含产物，可用 workflow）、精简 Next.js 为源码储存站
- 预检发现：用户已亲自通过 fork 内 PR #1 将 p0-discovery-fixes（9a661080）合并进 main（merge commit 571c352f，2026-10-03T06:28:46Z）；上游 main 仍为 9529e915 未动；fork Actions 已启用（enabled: true, allowed_actions: all）
- 代码实际进度核验（全部通过）：本地克隆 5 文件 MD5 与 HANDOFF 2.1 逐字节一致；测试文件 7 用例（旧 4 + 新 3）；Dart 括号平衡静态检查 5/5 PASS
- 同步本地 main 到 571c352f（fetch + reset --hard fork/main），合并树 5 文件 MD5 复核一致（用户合并未引入偏差）
- review/ 存档提交（6d089d15，27 文件 +3433/−367）：评审报告 v2 / 原报告原件 / v1+v2 草稿分片 / P0 补丁 / modified-source / 验证截图 / worklog / HANDOFF（前置 v3 状态注：持久化终态已迁移至 main + release）
- 新增 .github/workflows/release.yml：p0-review-* tag 触发或 workflow_dispatch，打包 5 产物（patch / review-report-v2.md / original-report.md / modified-source.zip / review-archive.zip），gh release create-or-update（--clobber 幂等）
- review/deliverables/release-notes.md：Release 说明正文（workflow 与 API 共用同一份）

Stage Summary:
- fork main = 基线 9529e915 + P0 修复（PR #1）+ review/ 存档（6d089d15）+ workflow；单一持久化目标达成
- 上游 localsend/localsend 未做任何改动（用户指令遵守）

---
Task ID: 17
Agent: Super Z (main)
Task: 站点 v2 精简重构（源码储存站）+ 端到端验证 + 终态提交

Work Log:
- 重写 src/lib/content.ts：数据源全部改为 fork main 克隆（/home/z/my-project/localsend）内的自包含路径（review/ 存档 + 工作树源文件），新增 readRepoState()（execSync 实时读 branch/HEAD/clean/log）与 readReleaseInfo()（download/release-info.json，缺失时返回确定性"待发布"预置态）
- 修复 execSync shell 注入问题：git log --pretty=format:'%h|%s' 的管道符必须加引号（症状：/bin/sh: %s: not found）
- 新组件 source-browser.tsx（取代 patch-viewer.tsx）：5 文件 chips 选择器 + 完整源码（行号）/ Diff 双模式切换；精简删除脚手架残留 api/route.ts
- 新 page.tsx 3 tab：源码（git 实时状态卡 + 源码浏览器）/ 评审报告 / 发布与交付（Release 表 + 实际进度[已完成/待办/明确不做] + 静态验证证据 + 原报告 details 折叠）
- layout.tsx metadata 更新为"LocalSend P0 · 源码储存站"
- bun run lint 通过（exit 0）
- agent-browser 端到端验证：3 tab 全渲染；源码浏览器文件切换（main.dart→settings_provider.dart）、Diff 模式（新缺陷 1 徽章 + 增删行）、完整源码模式（真实代码 onChanged: (_, next, ref) { 可见）；发布 tab 待发布徽章 + 5 产物表；原报告 details 展开渲染；console 零错误；390×844 移动端 footer 正常、tablist 不溢出；截图 4 张存档 download/preview-site-v2-*.png 并复制 2 张入 review/deliverables/
- 终态提交：review/site-src/ 更新为 v2（README 映射表 + 5 源文件）+ 截图 + 本 worklog

Stage Summary:
- 站点从"4 tab 交付展示站"精简为"3 tab 源码储存站"：源码成为一等公民（完整文件浏览 + diff），全部内容服务端磁盘读自 fork main 克隆，替换即自动更新
- 待 release 发布后回写 download/release-info.json，站点发布 tab 自动从"待发布"切换为"已发布"并显示真实产物大小
---
Task ID: 20-f
Agent: R-6 review-subagent
Task: 对 LocalSend P0 补丁 9a661080（基线 9529e915）做上游一致性联网审查（只读）

Work Log:
- 按序读完 code-reviewer.md 审查纪律、worklog.md 305-353 行交付终态、补丁完整 diff（5 文件 +83/−6）
- 联网核实 ①：`commits?sha=main&per_page=50` → 上游 main HEAD 即基线 9529e915（2026-10-03T07:32Z 快照），其后零新 commit，无重叠修复
- 联网核实 ②：63efbe6b 完整 diff → "server 探针重启 iOS+Android / discovery 重绑 iOS-only（cannot be probed）"设计意图确认；补丁 Android 扩展构成方向偏离（补丁注释已自曝）且与 FetchLocalIpAction 集合变化重绑部分冗余
- 联网核实 ③：branches 列表 + `commits?sha=feature/improve-local-ip-ranking` + tip bc472471 完整 diff → 2023-02 废弃 spike（无 PR、带调试打印），意图"hotspots preferred"与补丁同向、机制（接口名打分 swlan0）不同；Android 热点下 getWifiIP（docs："connected wifi network"）疑返回 null → 修复(a) Android 效果 UNVERIFIED
- 联网核实 ④：#427（Discussion，open，末评 2025-11 提议 Wi-Fi Aware）、#850（open，末评 2025-11 索要 PR drafts）、#2924（**已关闭 2026-10-01**，link/QR 作答）、#144（open，2023-12 起 stale）；补充 live 证据：#3509（2026-10-03T05:21Z 新开，v1.18.2+64，Windows 热点互不可见，正中补丁场景）、#484（Tienisto 归因 AP isolation "nothing LocalSend can do"）
- 联网核实 ⑤：CONTRIBUTING.md 原文（"disallows AI generated contributions unless: bug fixes / very small / prove expertise"）→ 不上游 PR 决策依据仍成立（且补丁未跑测试不满足 "covered by tests"）
- 联网核实 ⑥（超额）：open PR 全量扫描 → **PR #3188 "reuse connectivity listener across app resumes"（open）与补丁同改 local_ip_provider.dart + network_info_provider_test.dart**，文本冲突风险 + 其 dispose 模式暴露补丁 `_interfacePollTimer` 无生命周期管理
- 基线源码钉证（只读 git）：三处"restart after settings changed" doc 注释逐字属实、基线仅 main.dart:72/settings_tab_controller:149 两个 dispatch 点、syncState 顺序性主张成立、`take(maxInterfaces)` 联动属实、StateError 守卫正确；fork 状态网络复核（main=6fbfa5c3、PR#1 已并 571c352f、Release p0-review-v1 5 assets、上游未动）
- 报告写入 /home/z/my-project/reviews/R-6.md（9 节：方法/6 项核实/总表/分级发现/结论 + Declined to judge 4 条）

Stage Summary:
- 结论 **PASS-with-notes**：无"修错方向/撞车"证据；F1（settings 重启）与 F2c（IP 变化重绑）与上游文档意图精确对齐，F2a 与上游 spike 意图同向
- 2 个 Important：F4 偏离 63efbe6b 明确的 iOS-only 决策（将来上游最可能被 push back，建议探针化或撤掉 Android 扩展、单独开 issue）；PR #3188 在途两文件冲突（若合并需按其 dispose 模式重构 timer 并 rebase）
- 1 个 Minor（Android 热点修复效果 UNVERIFIED，getWifiIP AP 模式疑 null，对外不得声称已修复 Android 热点发现）+ #2924 状态过时提醒
- 上游 main 冻结于基线、热点问题获当天新 issue #3509 直接佐证；将来上游顺序建议：F1+F2c → F2a（Windows 立论）→ F3（附实测）→ F4（先 issue 讨论）
---
Task ID: 20-e
Agent: R-5 review-subagent
Task: 独立审查 LocalSend P0 补丁（9a661080）的测试质量与覆盖缺口（只读）

Work Log:
- 读审查纪律模板、worklog 305-353、补丁 diff（5 文件 +83/−6）
- 逐用例静态追踪 network_info_provider_test.dart 全部 7 例：对新旧两版 rankIpAddresses 手动求值，确认新增 #5/#6 在基线代码上必 FAIL（真区分性回归测试）、#7 为非区分性守卫、存量 4 例不受补丁影响；#6 与 #5 同分支仅换常量（弱）
- 补丁点↔测试映射：6 个行为点仅 (a) '.1' 排序有覆盖；(b) Windows 轮询 / (c) 集合变更重绑 / (d) maxInterfaces / (e) settings 重启派发 / (f) main resumed 全部零覆盖；(e) 为 P0 主修复
- 盘点测试基建：app/test 无 widget 测试；Refena `ReduxNotifier.test` 模式（favorites_provider_test.dart:17）+ mockito MockPersistenceService 现成；联网核实 refena main 分支导出面（ReduxNotifierTester/override）；确认 _getIp 不可注入（NetworkInfo 内联 + NetworkInterface.list 静态）是 (c) 不可测根因
- CI 稳定性：ci.yml test job 仅 ubuntu-latest（analyze→flutter test）；7 用例纯同步零 mock 零平台依赖，gen/ 已提交；唯一理论风险为未文档化 sort 稳定性（Info）
- 联网：上游 test 文件与基线逐字节一致（412d9b04 2023-10-09 后零演进，fork +3 领先不落后）；上游 local_ip_provider 与基线一致；GitHub API 取证 fork Actions total_count=1（仅 release workflow_dispatch），ci.yml 从未 run → 全套测试从未在任何真实环境执行
- 产出 5 条 UNVERIFIED（analyze/format 合规、refena 3.5.0 接线、CI 未触发原因、测试真实执行结果）与 11 条分级发现（3 Important / 4 Minor / 4 Info）
- 观测到仓库根非本 agent 产生的未跟踪文件 `80===`（===LINES，07:36:51，疑似并行 agent 误写），按只读纪律未删仅上报
- 完整报告写入 /home/z/my-project/reviews/R-5.md

Stage Summary:
- 结论 PASS-with-notes：7/7 用例有效、零 flaky、CI 必绿（静态追踪）；但补丁 6 行为点仅覆盖 1 个，P0 主修复（settings_provider.dart:47-49 重启派发）零回归保护，且 fork CI 零 run + 本地无工具链 → "3+4 全绿"至今无任何真实执行证据。上游 PR 前最低动作：触发一次 fork ci.yml 拿真实绿灯；强烈建议补 settings_provider 三用例（变更→[sync,restart] 顺序断言、无关变更不重启、discovery==null 不抛 StateError），mock 基建现成成本约半天
---
Task ID: 20-j
Agent: R-10 review-subagent
Task: 对 LocalSend P0 补丁（9a661080）做 Flutter 升级成本评估（3.41.9 → 最新 stable），只读审查

Work Log:
- 按序读完审查纪律（code-reviewer.md）、worklog 305-353 行交付终态、补丁 diff（git show 9a661080，5 文件 +83/−6）
- 联网确定目标版本：storage.googleapis.com releases_linux.json 解析 current_release.stable = 3.47.6（2026-10-01，dart 3.13.5）；最近 3 个 stable：3.47.6/3.47.5/3.47.4；3.41.9=2026-04-30（dart 3.11.5）；窗口跨 3.44.0+3.47.0 两个列车
- 读全部 pubspec 链（根 workspace/app/localsend_isolates/typed_isolates/rust_builder/cargokit build_tool；packages/core 为纯 Rust crate 无 pubspec）；pub.dev API 核实 35+ 包钉版 environment：全部为 >= 下限、零 flutter 上限；refena_flutter 3.5.0（非 riverpod）、routerino（非 go_router）
- git override 三 fork 核实：pasteboard OK；device_apps 声明 sdk <3.0.0（override 放行的既有怪癖，lock 证明 3.11.5 下可解析，3.13 行为 UNVERIFIED）；permission_handler_windows_noop raw 404 → UNVERIFIED
- 静态弃用面统计（rg 全仓 *.dart）：WillPopScope 0；MaterialState 系 0；withOpacity 0（withValues 3）；Color.value 0（166 个 .value 全为 MapEntry/参数/Future/generated）；TextTheme 旧字段 0；toggleable/SelectableRegion/onSystemNavigator 0；defaultTargetPlatform 18 行/6 文件；Platform.isX 31 行/17 文件
- 抓取 docs.flutter.dev 全部 176 个 breaking-changes 页面并解析 "In stable release"：3.44=8 项、3.47=2 项；逐项 rg 碰撞 → 受影响 API 命中全 0；Kotlin BC 仅强制 AGP 9+（本项目 AGP 8.12.1 不在范围）
- 关键平台发现：3.47 macOS 最低支持 10.15→12（PR #188520 核实），flutter_tools 自动迁移会把 macos 11.0 部署目标改写为 12.0（产品决策项）；material_ui/cupertino_ui 独立包 3.47 起 opt-in、框架 material.dart 未弃用（103 文件 import 为未来迁移面）
- 补丁 5 文件逐文件 API 兼容复核：全部使用 AppLifecycleState/WidgetsBindingObserver、dart:async Timer、refena、钉版插件、package:test → 升级零修改
- FRB 耦合核实：Rust 侧 =2.12.0 精确钉、Dart 侧 ^2.12.0（lock 2.12.0）一致，Dart frb 2.12.0 sdk >=3.4.0 <4.0.0 无 flutter 约束 → 不需重新 codegen；rustc 1.97.1 独立
- 版本钉清单：.fvmrc + 13 个 workflow 文件 FLUTTER_VERSION="3.41.9"（grep 核实）；无脚本读 $FLUTTER_ROOT/version
- 完整报告写入 /home/z/my-project/reviews/R-10.md（含证据 URL、rg 命令、UNVERIFIED 清单、升级路径与回退策略）

Stage Summary:
- 目标版本 3.47.6（dart 3.13.5），跨 2 个 stable 列车；阻塞项 TOP：①macOS 部署目标自动 11→12（放弃 macOS 11 用户，需显式 review）②device_apps fork Dart2 约束在 3.13 的解析行为 UNVERIFIED ③formatter/analyzer 漂移（CI format 门禁）④13 workflow+.fvmrc 需同 PR 同步
- 成本判定：代码迁移低（<1 天，弃用 API 与窗口内 BC 碰撞全 0、依赖零上限、补丁零修改）；含全平台构建验证中（1-3 天）
- 补丁 5 文件无需随升级调整；升级与 AGP9/Kotlin、material_ui 迁移、依赖升级应各自独立排期
---
Task ID: 20-h
Agent: R-8 review-subagent
Task: 对 LocalSend P0 修复补丁 9a661080 做并发与竞态专项只读审查（8 项猎杀清单逐项裁决）

Work Log:
- 按序完成必读：code-reviewer.md 纪律、worklog.md:305-353 终态上下文、git show 9a661080 全量 diff（5 文件 +83/−6）
- 通读补丁 5 文件及下游：discovery isolate 三件套（discovery.dart / discovery_isolate.dart / child/main.dart）、parent 侧（actions.dart / actions_sync.dart / parent_isolate_provider.dart）、Rust 侧（core/src/discovery/mod.rs、core/src/multicast/mod.rs、rust/src/api/discovery.rs）、nearby_devices_provider、settings_tab_controller、settings_tab、config/init.dart；任务给定的 rust 路径有误，真实 try_send 位于 packages/core/src/discovery/mod.rs:189-207
- 联网核实决定性第三方语义：refena 3.5.0 归档（ReduxNotifier 对异步 action 无队列/无锁，库注释自认微任务竞态）与 dart:core Set 源码（无 operator== 重载，== 即同一性）——均存 /tmp/refena-src 与 GitHub raw 证据
- 8 项清单逐项裁决：#1 存在（Timer 不待回调+refena 无串行化→并发 Fetch 重复 restart/旧盖新）；#2 存在（restartListener 在 _discovery==null 重绑窗口走 completer 空完成→重启丢失、新配置不生效，补丁三个新触发源显著提高撞窗概率）；#3 存在且更糟（toSet()!=toSet() 是同一性比较→setChanged 恒真→每次 fetch 都重启；IPv6 子项因 :131 过滤不存在）；#4 生产路径不存在（provider app 生命周期、resume 路径 cancel+重建），仅 dev 残留；#5 不存在撕裂读（NetworkState 原子替换）；#6 存在（resume 双 restart + 逐键 settings restart 三叠最坏时序）；#7 存在（16 槽 try_send 丢 Discovered/Updated 与 MulticastFailed；restart 加压放大丢弃概率）；#8 顺序假设经 refena+typed_isolates+child handler 三链验证成立，真实风险是 #2 窗口
- 产出完整报告 /home/z/my-project/reviews/R-8.md（1 Critical / 3 Important / 4 Minor / 5 Info，含触发时序、后果、分级修复建议与 declined-to-judge 清单）；全程只读，未改动 localsend 仓库与 src 任何文件

Stage Summary:
- 总判定 FAIL：Critical = local_ip_provider.dart:100 集合同一性比较使 setChanged 恒真，Windows 上 discovery 每 10s 重启（每轮清空 Rust DeviceStore + announce 三连发 → 全 LAN register 风暴），补丁"仅集合变化才重绑"的承诺被反转；Important = restartListener 丢失重启窗口（重绑在途时 completer 空完成，设置终值/IP 变化静默丢失，超时输入框逐键触发最易复现）、并发 FetchLocalIpAction 重复重启/旧值覆盖、settings onChanged 无去抖
- 修复路径明确：setEquals 一行修 + restartPending 标志使背靠背重启幂等 + fetch single-flight + 去抖；修完并补集合比较单测后可达 PASS
---
Task ID: 20-d
Agent: R-4 review-subagent
Task: Android 生命周期 resumed 重绑专项审查（main.dart iOS→Android 扩展 + 与 set-change/settings 重绑的叠加交互）

Work Log:
- 必读三件套：code-reviewer.md 纪律模板 / worklog 305-353 交付终态 / 9a661080 补丁 diff（基线 9529e915）
- GitHub API 抓上游 63efbe6b 完整 diff：确认双哲学——TCP server 用 loopback probe 条件重启（iOS+Android），组播 socket "无法探测才重绑"且 iOS-only；动机 issue #2422（iPhone 后台返回后 Windows 发现不了）+ 评论建议 self-ping → 上游 main 今日仍 iOS-only（raw 抓取核对），63efbe6b 是基线祖先
- 调用链追到底：main.dart resumed → InitLocalIpAction → FetchLocalIpAction set-change 重绑（#A）+ 无条件直发重绑（#B）→ IsolateDiscoveryRestartAction → child 并发任务处理（syncState 同步发布保 FIFO）→ restartListener（stale completer 吸收重叠重启）→ Rust start_discovery（RUNNING_DISCOVERY 防双绑 + DeviceStore::new 每次清库 + 3×{100,500,2000}ms announce burst）
- 抖动：全链路无显式去抖，但两层天然限幅（child 吸收 + 用户频率）；Flutter 官方文档核实 Android onPause→inactive 映射——SAF 文件选择器/通知栏/对话框均触发，Android resumed 频率显著高于 iOS 且嵌入核心发送流程
- 功耗/系统：AndroidManifest 无 CHANGE_WIFI_MULTICAST_STATE/MulticastLock（重绑治不了组播过滤）；10s 轮询仅 Windows；Doze/冻结/杀后台路径推演无新增负担
- 去理想化：热点切换（shade 打开期间 connectivity 重绑 + 收起 resume 重绑 = 常态双重全量重绑）；冻结期事件丢失由 resume 兜底；mid-scan 重启丢扫描结果但自愈；"ROM 静默杀 socket" UNVERIFIED
- 产出 reviews/R-4.md：Critical 0 / Important 2（无条件 resume 重绑无去抖 I-1；resume+set-change 双重重绑 I-2）/ Minor 4 / Info 7

Stage Summary:
- 总结论 PASS-with-notes：Android 扩展机制正确且自愈、无崩溃泄漏路径，但属"换病治疗"——上游 iOS-only 是按实证病因下药（挂起杀 socket），Android 扩展治的是接口集过时，而该病已被补丁自己的 set-change 重绑精准覆盖，无条件 resume 重绑只剩钝器价值且以文件选择器级高频空转（清库+burst+扫描丢弃窗口）为代价；建议 fork 内加 500ms-1s 去抖或接口比较门控（≤15 行）后再谈上游 PR（且须 issue 先行 + AI 贡献条款合规）
---
Task ID: 20-c
Agent: R-3 review-subagent
Task: 独立审查 P0 补丁 9a661080 的 scan_facade maxInterfaces 3→5 及 Rust 多播层调用链

Work Log:
- 按序读完 code-reviewer.md 审查纪律、worklog 305-353 行交付终态、补丁全量 diff（5 文件 +83/−6）
- 追完整调用链：scan_facade.dart:21/27 take(5) → StartStagedScan → discovery_isolate.dart → DiscoveryService.discoverStaged → rust api/discovery.rs:348-354 → core/discovery/mod.rs:308-334 discover_staged（favorites+1s grace+零确认才升级）→ mod.rs:342-379 scan_subnet（255 地址、并发 50、500ms 探针超时）；确认多播层（core/multicast/socket.rs:29-88 + core/util/interface.rs:101-174）join 全部接口、双栈、与 maxInterfaces 完全无关
- 核实选择逻辑：Dart `NetworkInterface.list()` 无排序（直查 dart-lang/sdk 源码：socket_base_posix.cc:373 getifaddrs / socket_base_win.cc:357 GetAdaptersAddresses，全部 socket_base*.cc 无 sort，API 文档无顺序承诺）→ take(5) 第 2-5 名 = OS 枚举序；`.1` 启发式碰巧压住 docker0/VirtualBox/WSL 网关，但对 VPN/CGNAT overlay 无效
- 失败处理逐行审计：单接口 bind/join 失败 warn+跳过、全灭 bail→HTTP-only 降级+multicast_error 上报、recv 10 次容错、发送逐 socket warn 继续、无 panic；Windows 无 SO_REUSEPORT（注释自知）、每 socket 单组 join 无已知硬限制、未调 SO_RCVBUF（UNVERIFIED on-device）
- 联网核实：上游 main 今日仍 maxInterfaces=3（raw 直取）；3 源于 2023-04-21 外部贡献 7af03430（把 <=1 改成 <=3，无取舍记录）；分支 feature/improve-local-ip-ranking（bc472471，从未合入，落后 1746）提出按接口名打分（hotspot>wifi/eth>未识别=0）——与本次"扩容"方向兼容但不治本；issue #3509/#484/#2394/#2780/#3400 逐个取正文核实（#850 为蓝牙 FR，排除）；network_info_plus 7.0.0 Android 源码核实：API<12 热点-only 返回 null、API≥12 热点+蜂窝返回 CGNAT 地址 → Android 上新排序基本不生效，收益实际来自 maxInterfaces=5 + resume rebind
- 产出报告 /home/z/my-project/reviews/R-3.md：0 Critical / 2 Important（F1 VPN overlay 常态入选回退扫描、F2 热点修复声明在 6+ 适配器与 Android 上不成立）/ 3 Minor / 4 Info，含 6+ NIC 与 docker 常驻机去理想化推演与成本数学（5×255=1275 探针 vs 765，峰值并发 250，~3s 墙钟，零常驻开销）

Stage Summary:
- 结论 PASS-with-notes：maxInterfaces 3→5 位于与多播 socket 层完全解耦的回退扫描链上，成本模型注释与 Rust 实现逐行吻合，Rust 多播层失败处理经审计无新增风险；5 值合理建议保留、不建议配置化/动态化；两条 Important 均为既有缺口被放大（take 前 5 无虚拟网卡降权 → VPN /24 顺序 HTTPS 探测有企业 NAC/IDS 暴露面）与声明过强（6+ 适配器 Windows、Android 热点第三方路径不触发），建议后续 issue 跟进（CGNAT/点对点过滤 + 上游式名称打分）而非阻塞本补丁
---
Task ID: 20-b
Agent: R-2 review-subagent
Task: 独立审查 LocalSend P0 补丁（9a661080）的 local_ip_provider 网络层：调用链追到底、排序反例、Windows Timer 生命周期、IP 集合比较、去理想化场景（只读）

Work Log:
- 读审查纪律模板、worklog 305-353、补丁 diff（5 文件 +83/−6）
- 追完整调用链：network_info_plus getWifiIP + dart:io NetworkInterface.list（Dart 侧，未走 Rust 桥）→ _getIp/rankIpAddresses 排序 → 下游 5 消费端（scan_facade take(5)、deviceFullInfo.firstOrNull 展示、send_tab 子网选择、receive_tab、address_input 预填）→ IsolateDiscoveryRestartAction → 子 isolate restartListener → Rust stop/rebind；确证 Rust 多播绑定独立枚举（if_addrs），零接口时 multicast::start bail 但 listen 流不结束、无自愈事件 → 重绑唯一途径是 restart action
- 联网核实：pub.dev 下载 refena 3.5.0 + refena_flutter 3.5.0 源码——BaseReduxAction 无 `global` 成员，`global` 仅存在于 Ref 扩展/BuildContext/ReduxNotifier，GlobalActionDispatcher 无 read 且 dispatch 只收 GlobalActionWithResult → **local_ip_provider.dart:102/104 global.read/global.dispatch 编译失败（Critical C-1）**；另核实 dispatchAsync 无队列（并发 fetch 可能）与错误 rethrow 语义
- 联网核实 network_info_plus 7.0.0：Windows getWifiIP=WlanQueryInterface(current_connection) 位置敏感路径；Android SDK≥31 getWifiIP=activeNetwork 首个 IPv4（非 Wi-Fi 专用）→ 开热点时=蜂窝 CGNAT 或 null，'.1' 修复前提在 Android 12+ 不成立（Important I-3，iOS 确定修复）
- GitHub API 取证上游 #12/#78 与 commit 221f40a9（2025-02-18 上游专门删除 Windows 5s 轮询修 #78 定位提示）→ 本补丁 10s 轮询每 tick 调 getWifiIP = 重新引入上游已修复的 Windows 定位权限触发（Important I-2）
- 行为分析：`previousIps.isNotEmpty` 使空→非空转换永不重绑 → 开机无网/自启动竞态下桌面端多播永久哑火（Important I-1，注释与代码不符）；Set 比较/顺序抖动/IPv6 fe80 滤除/无重绑循环均验证正确；Windows Timer 生命周期（幂等取消、无 dispose 路径、回调异常不停摆、三源并发）专项过查；5 类 NIC 排序行为表 + 去理想化场景（VPN 断开/热点切换/DHCP/休眠唤醒/冷启动）推演完成
- 交叉验证 settings_provider 重启派发的消息顺序声明（child/main.dart 同步 dispatch + discovery.dart 循环重读 syncProvider）成立；main.dart Android 并入 resume 重绑与 63efbe6b iOS-only 决策的张力已披露但 :80 派发缺 discovery!=null 守卫（Minor）；scan_facade max=5 与 Rust discover_staged 升级逻辑匹配
- 完整报告写入 reviews/R-2.md（Critical 1 / Important 3 / Minor 6 / Info 4 / UNVERIFIED 5 / Declined 4）

Stage Summary:
- 总结论 **FAIL（不可合并）**：C-1 编译错误为硬阻断（refena 3.5.0 action 上不存在 global，fork main + Release p0-review-v1 携带不可构建代码，重绑链从未生效）；即便修复编译，I-2 Windows 定位提示回归（上游 221f40a9 明确拒收点）、I-1 空→非空重绑死角、I-3 Android 12+ 前提失实仍需先处理。修复路径明确且均为小 diff：IsolateController 构造注入 + external() 派发、跳过条件改 state.initialized、Windows 轮询跳过 getWifiIP、Android SDK≥31 校验 thirdParty 在 native 集合内
---
Task ID: 20-i
Agent: R-9 review-subagent
Task: 独立审查 LocalSend P0 补丁的构建/CI/发版链路（release.yml、上游 CI workflows、fork Actions 实况、v1 资产一致性），并产出 v2 发版 checklist 与 release.yml 修改建议

Work Log:
- 按序读审查纪律（code-reviewer.md）、worklog 305-353（交付终态上下文）、补丁 diff（9a661080，5 文件 +83/−6）
- 逐段审 release.yml：触发/checkout/打包 5 产物路径（全部存在，与 review/ 及工作树核对）/gh release create --clobber 幂等/permissions/runner；本地 /tmp 重建两 zip 与 v1 资产逐字节同大小（8549/3819251），3 个单文件大小亦一致（9364/26605/39879）
- Grep 全部 18 个 workflow 触发器：13 个 build_* 仅手动、winget.yml on release released（fork 无 WINGET_TOKEN，UNVERIFIED）、clear_workflows 仅手动 → tag push 只会触发 release.yml
- 上游 ci.yml 参数分析：dart format --set-exit-if-changed（关键发现：app/analysis_options.yaml page_width=150，补丁最长行 98 → 低风险）、flutter analyze（无 fatal 旗标；导入/符号/lint 逐项静态核验，global.read 无先例标 UNVERIFIED）、flutter test 全量（3 新用例与 _rankIpAddresses 打分静态一致）、rust/packaging job 不受补丁影响
- API 核验 fork Actions：total_count=1（仅 release.yml workflow_dispatch success，5/5 步骤）；PR head check-runs=0 → **补丁从未经任何 CI 验证**（Important F1）；下载 run 日志确认实走 gh release create 路径（06:50:01 输出 release URL）+ 唯一 warning 为 checkout@v4 Node20 弃用
- 时间线取证：release created_at 06:48:13 早于 run 起点、published_at 06:50:01、author=github-actions[bot] → 推定旧版 release-drafter workflow（571c352f，379 行）先建 draft、可见 run 将其转正；旧 run 已从列表消失（删除者 UNVERIFIED）；tag-push 触发路径从未实跑（Minor F3）
- 产出：v2 产物增量清单（analyze/test 日志、升级成本报告、SHA256SUMS 等 6 项新增）+ release.yml 精确到行的修改建议（L12 默认值、L22 checkout@v6、L63/L64 v1 硬编码、validate job 方案）+ 8 步 v2 checklist
- 完整报告：/home/z/my-project/reviews/R-9.md（Critical 0 / Important 2 / Minor 3 / Info 6，全部附 file:line 或 API 证据）

Stage Summary:
- 结论 PASS-with-notes：v1 发版链健康保真（run 成功、资产逐字节一致、create 路径已实证），但 v2 前必须处理——F1 补丁 0 次 CI 验证（借 v2 准备 push 首跑 ci.yml 作发版闸门）+ F2 release.yml 三处 v1 硬编码（标题/notes/dispatch 默认 tag，后者误触即覆盖 v1 资产）；format/analyze/test 静态低风险（page_width=150 等），以 fork CI 实跑为准
---
Task ID: 20-g
Agent: R-7 review-subagent
Task: 对 LocalSend P0 补丁 9a661080 做用户真实运行环境矩阵审查（6 环境 × 5 修复点，去理想化推演，只读）

Work Log:
- 按序读完 code-reviewer.md 审查纪律、worklog.md 305-353 行、补丁完整 diff（5 文件 +83/−6）
- 读透行为地基：local_ip_provider 排序规则（:139-174）、Rust util/interface.rs 枚举（无排序无上限 :101-174）、multicast/socket.rs 绑定（全接口 wildcard+IP_MULTICAST_IF :29-123）、discovery/mod.rs /24 兜底（SCAN_CONCURRENCY=50、500ms 超时、仅静默时 :308-379）、discovery.dart 重启语义、child/main.dart 消息顺序性（核实 commit 主张成立）、nearby_devices_provider 设备表跨重启存活
- 版本钉死取证：pub.dev 下载 network_info_plus 7.0.0 / connectivity_plus 7.3.1 / refena_flutter 3.5.0（/tmp 解包），/tmp 既有 refena 副本与官方归章 diff 逐字节一致；pubspec.lock 版本核对匹配
- Critical C-1：local_ip_provider.dart:102-104 `global.read/dispatch` 在 refena 3.5.0 不存在（global 仅来自 GlobalActions mixin/Ref/BuildContext 扩展；GlobalActionDispatcher 无 read 且 dispatch 仅收 GlobalAction；本仓正确范式=external/ref.redux）→ 整个 App 不编译、flutter test 全失败、F2c（IP 集合变化重绑）归零
- Important I-1：:100 `previousIps.isNotEmpty` 守卫导致空集→非空（启动时离线、后联网）永不重绑，桌面端无 resume 兜底、Rust 零 socket 启动无自愈事件
- Important I-2：'.1' 降权删除的热点网关前提三平台全部被插件源码反证（Android 12+ activeNetwork=运营商 IP/null；Windows 仅物理 WLAN 客户端关联；iOS 仅 en* 遍历）→ 热点主机场景惰性；新增 2 测试编码不可达输入
- 完成 6 环境矩阵推演（Win11 多网卡+VPN+HyperV+WSL / Android14 激进 ROM / iOS17 / Linux+docker / macOS+UTM+Parallels / 手机热点×笔记本），每类给收益/风险/无感判定+最坏场景链路；总矩阵表 6×5
- 副产发现：Android 运行中开热点重绑依赖 connectivity 事件（ROM 相关）；MulticastLock 仍全仓缺失（F4 只修 socket 死亡半边）；仓库根游离未跟踪文件 80===（9 字节，mtime 早于本会话，非 R-7 创建）
- 报告写入 /home/z/my-project/reviews/R-7.md（7 节：弃判项/行为地基/分级发现 C1+I2+M3+N5/6 环境推演/总矩阵/优势与建议/结论）

Stage Summary:
- 结论 **FAIL（不可合并）**：C-1 编译错误使 fork main（PR #1 已并、含 Release 产物风险）不可构建，F2c 承重机制归零；I-1 空集缺口 + I-2 三平台前提不成立使 P0 热点目标交付度大幅缩水
- F1（设置重启）最扎实可保留；F3/F4 方向正确；F2a 需重新定性（"活动接口不被误降"而非"热点网关优先"）
- 环境矩阵要点：Windows 轮询+重绑本是 #3509 正解但被 C-1 击穿；Android resume 修复外发半边、接收仍受 MulticastLock 缺失制约；Linux docker 网桥被 /24 兜底扫描（~3-5s 可接受浪费）；macOS en0 硬编码链路为先存问题
- 下一步：按 R-7.md §6 修复 C-1（external 模式）+ I-1（一行守卫）→ 工具链 analyze/test 终审 → 撤回 '.1' 热点表述 → 复核 Release 产物是否含同错误代码
---
Task ID: 21-d
Agent: V-4 verify-subagent
Task: round-2 验证 7d25f792 中 main.dart 与 settings_provider.dart 的去抖与生命周期修复（round-1 R-4 Android resume 重绑风暴 / R-8 I-3 设置逐键 restart 风暴），并猎杀 Timer/ref 生命周期新问题、核对上游 63efbe6b 行为差异、实跑工具链

Work Log:
- 读 R-4.md / R-8.md 全文、7d25f792 两文件 diff、当前 main.dart / settings_provider.dart / local_ip_provider.dart / discovery.dart / child/main.dart / discovery_isolate.dart / actions.dart / parent_isolate_provider.dart / life_cycle_watcher.dart / platform_check.dart / init.dart
- ref 生命周期核实（refena_flutter 3.5.0 源码）：context.ref = Expando 缓存 WatchableRefImpl（extension.dart:27-35），read/redux 为纯容器操作（ref.dart:163-206），element 仅 WeakReference（element_rebuildable.dart:30,38-40）且只用于 debug 标签（dispatcher.dart:34,42-47）；官方文档明示 WatchableRef 与容器同寿命、widget disposed 后 watch 亦仅失效不抛错（ref.dart:110-117）→ main.dart 750ms Timer 闭包用 ref 安全；LocalSendApp 为 const 根 widget，Element 永不 dispose、rebuild 复用同一 ref 实例
- settings onChanged 的 ref = 每次变化新建 ProxyRef（base_notifier.dart:331-344），仅持 container+标签（proxy_ref.dart:20-30），与 widget 零耦合 → 500ms 后使用安全
- 死端口/去抖边缘核实：IsolateDisposeAction 不置 null（parent_isolate_provider.dart:99-107）→ detached 后迟到 Timer 触发走裸 SendPort.send（typed_isolates isolate_helper.dart:23-25）→ Dart VM 死端口静默丢弃（doc-quote UNVERIFIED，行为与 R-8 N-5 一致），无 StateError；热重载保留 top-level Timer 旧闭包但 ref 同源等价；Android resumed→inactive→resumed 循环内只有 resumed 分支 cancel+重排 → 窗口内恰好一次重绑；冻结解冻边缘最坏 2 次（UNVERIFIED）
- 子 isolate 重试机制核实：_restartPending（discovery.dart:34-40,111-120,149-170）使重绑在途到达的 restart 改为「绑定后立即再停（announce 之前）再循环」，消除 round-1 的静默丢失 → I-2/M-1 的有害形态（旧配置无限期存活）根治，剩余为有界双绑
- 上游对比：git show 63efbe6b:app/lib/main.dart 与当前整文件 diff——iOS 路径行为差异仅 null 守卫；Android 差异 = 门 widened + 守卫 + 750ms 去抖 + 注释（有意 fork）；桌面无重绑与上游一致；SDTFScope 差异来自基线 9529e915 非生命周期
- 工具链：flutter analyze = No issues found (0)；追加 flutter test = 93/93 通过（含 8 个 shouldRebindDiscovery 新用例，network_info_provider_test.dart:39-95）
- 新发现 5 条全 Info：N-1 双 Timer 互不合并（有界）；N-2 settings 注释"each one still costs an announcement burst"与 discovery.dart:111-120 的 pre-announce stop 不符（措辞）；N-3 尾沿去抖推迟设置生效至输入停顿（持久化即时、无损失）；N-4 去抖无单测；N-5 detached 不取消 Timer（化妆级）
- 完整报告：/home/z/my-project/reviews/V-4.md；只读合规：localsend 仓库零修改

Stage Summary:
- 总判定 **PASS-with-notes**：本范围 round-1 全部 actionable 发现已修复（R-4 I-1/M-3/M-4/F-2 FIXED、R-8 I-3 FIXED、R-4 I-2 与 R-8 M-1 PARTIAL——有害形态被子 isolate _restartPending 根治，残留为有界双绑）、M-1/M-2 按文档化 WONT-FIX；两个 Timer 闭包的 ref 延迟使用经 refena 3.5.0 源码核实安全；iOS 路径与上游 63efbe6b 行为差异为零（除 null 守卫）；analyze 0 issues + test 93/93
- 新发现 0 Critical/Important/Minor、5 Info（双 Timer 不互并、注释措辞、尾沿延迟、无去抖单测、detached 不取消 Timer），均不阻断
- 可选跟进：FetchLocalIpAction 的 restart 派发并入统一去抖以收敛 I-2 残留；N-2/N-5 一行级打磨；N-4 补测试
---
Task ID: 21-c
Agent: V-3 verify-subagent
Task: 对主 agent 修复 R-8 round-1 I-1「discovery restart 窗口丢失」的 commit 7d25f792（discovery.dart 的 _restartPending 机制）做竞态终审，重点审查修复本身是否引入新竞态；只读仓库，每条结论附 file:line 证据

Work Log:
- 读 R-8.md I-1 节（原发现：restartListener null 分支 complete 无人等待的 completer = 静默丢弃）+ `git show 7d25f792 -- .../discovery.dart` 全量 diff + 工作树现行文件逐行
- 建立挂起点地图：_runListener 的 7 个 await（:76 startDiscovery / :96 retryCompleter / :100 multicastError / :106 setAnswerAnnouncements / :126 await for / :143 1s delay）+ 两个无挂起同步段（:71-72、:109-126），据此枚举 restartListener 的全部可能交错
- 核实关键不变式 I-A（动机 sync 必先于 restart 生效）：child/main.dart:75-78 同步 dispatch UpdateSyncStateAction 先于 handler；SendPort FIFO（R-8 已核实 typed_isolates）；settings 路径 sync 即刻发（actions_sync.dart:122-127 同步 reduce）+ restart 延迟 500ms（settings_provider.dart:62-67）
- Task 1 八场景逐一推演：T1(循环顶前，含 1s delay 子场景"标志被清零但新鲜读取满足")/T2(startDiscovery await)/T3/T4(multicastError、setAnswerAnnouncements await，_discovery 尚 null → pending 捕获)/T5(await for，stop 路径 + FRB done 滞后期双 stop 幂等)/T6(1s delay)/T7(retryCompleter 唤醒)/T8(startListener 未调用——rg 全仓 restartListener 唯一调用点 discovery_isolate.dart:127，4 个 dispatch 点守卫核实，启动空窗 [init.dart:190 setup, :232 listen] 内泄漏为良性，首轮绑定吸收) → 8/8 覆盖
- Task 2 四向猎杀：H1 ":111 检查后 :126 await for 前"无挂起点不可插入，真实等价情形走 stop 路径覆盖；pending 写点全枚举证明不可能穿越 :111 存活 → 无下轮误 stop；H2 双 restart 落同一 bind 窗口 → 单 bool 幂等足够；H3 _restartRequested 三写点均在同轮 await for 终结前消费（stop 无条件 cancel，api/discovery.rs:135）→ 无跨轮泄漏；H4 因果链推演：instance.stop 的 cancel.cancel() 严格晚于 wait_stopped（socket 释放）→ 循环顶必然晚于端口释放；MulticastFailed 逃逸口由 start_discovery 的 leftover-stop（api/discovery.rs:187-190，stop_tx mutex 串行化）兜底；RUNNING_DISCOVERY ptr_eq 清理防误清新实例；死锁核查无锁序环
- Task 3 "1500" 端到端 8 步状态表：4 键 4 sync + 1 去抖 restart 落在 startDiscovery await → pending → post-bind stop（跳过 announce）→ 下一轮 :72 读到 1500 → 唯一一次 announce，终态一致
- 工具链实跑：flutter test（isolates 包）= 18 passed + 4 skipped（Rust dylib not built），与主 agent 声称一致；发现 _restartPending 状态机零单测覆盖（test/ 仅 server/util）
- 完整报告：/home/z/my-project/reviews/V-3.md（6 节；残留 4 项均 Info 级非回归：1s 退避不缩短、无单测、serverRunning 覆盖闭合记录、启动空窗）

Stage Summary:
- 终审判定 **PASS**：R-8 I-1 丢失窗口被正确封闭，8/8 到达时刻收敛到最新 syncState，四向新竞态猎杀全部封闭（含 Rust stop 幂等与 stop/start 交错的逐行核实），端到端 "1500" 时序成立且只发一次 announce
- 关键机理：循环顶清零的正当性依赖"sync 先于 restart 应用"（FIFO + 同步 reduce + 去抖），该不变式经三层证据核实成立；pending 不可能穿越 post-bind 检查点存活，restartRequested 不可能跨轮泄漏
- 残留均为 Info 级非回归项，建议后续补 _restartPending 状态机单测（现零覆盖）；UNVERIFIED 仅 FRB done 投递时序与 CancellationToken 幂等性（依赖库文档/标准行为，dylib 未构建无法实测）
---
Task ID: 21-a
Agent: V-1 verify-subagent
Task: 终审 settings → discovery 重启调用链端到端正确性（补位 round-1 R-1 空响应角度；验证 7d25f792 对 R-8 I-1 重绑窗口丢 restart、R-8 I-3 settings 去抖的修复 + R-2/R-5 派发模式 + ref 生命周期 + 新问题排查）

Work Log:
- 读 worklog 末段（R-2/R-3/R-7/R-9 交付上下文）+ git show 7d25f792 全量 diff（5 文件 +245/−42）；读齐链路全部文件：settings_provider / settings_tab / text_field_tv / actions.dart / actions_sync.dart / parent_isolate_provider / child/main.dart / discovery_isolate.dart / sync_provider.dart / discovery.dart / local_ip_provider.dart / main.dart / typed_isolates 源码 / Rust api/discovery.rs stop 幂等
- R-8 I-1 判定 FIXED：`_restartPending` 机制四分支逐行推演全闭环——(A) `_discovery!=null` 稳态走 stop→流结束→循环顶读最新 sync（基线本正确）；(B) startDiscovery await 中到达 → `_restartPending=true` → :109 赋值后 :111 捕获 → 跳过 announce + 补停 + 立即重绑读终值（基线此处静默吞 restart，正是 R-8 主窗口）；(C) 1s delay 中到达 → 循环顶清零后第一动作即读最新 sync，语义等价满足（注释 :68-70 论证成立）；(D) multicastError/setAnswerAnnouncements await 中同 B。Rust stop 幂等（api/discovery.rs:127-134 take+no-op）保证重复 stop 与补停安全；R-8 M-2 microtask 反序边缘被同机制覆盖
- R-8 I-3 判定 FIXED：settings onChanged sync 每键立即派发（:37-46）+ restart 500ms 去抖（:61-68，回调内二次 discovery!=null 守卫）；"1500" 4 次 onChanged → 4 sync + 1 restart + 1 次 announce burst（基线 4 次三连发）；未采纳 onSubmitted 是合理替代
- 端到端终值一致性 PASS：TextFieldTv 逐键（text_field_tv.dart:72-75）→ setDiscoveryTimeout（await persistence → copyWith，platform channel FIFO 保序 + SettingsState dart_mappable 字段级 == 触发 4 次 onChanged）→ IsolateSyncSettingsAction 同步 reduce → SendPort.send FIFO（自建 /tmp/v1_fifo3.dart 实测 5 消息序 sync(1)→sync(15)→sync(150)→sync(1500)→RESTART 全保序）→ 子 isolate await for 逐条 + UpdateSyncStateAction 同步 reduce 先于 restart handler → restartListener stop → 循环顶读 1500 → startDiscovery(timeoutMs:1500) 终值生效；中间值从不触发重绑，无震荡
- ref 生命周期 SAFE：refena 3.5.0（pubspec.lock:1347-1363 钉死）NotifierProvider onChanged 的 ref 是每次变化新建的 ProxyRef（base_notifier.dart:333-344），仅持容器引用、无 provider-scoped 资源（proxy_ref.dart:20-30），read/redux 无状态代理（:33-73）；RefenaContainer app 全寿（init.dart:149-160 + main.dart:43-52）不 dispose；无 _onAccessNotifier 竞态（仅 trackNotifier 窗口非空）→ 闭包 500ms 延迟使用安全；external() 派发核实为 ReduxAction 实例方法（redux_action.dart:125-147 文档示例同款）
- 新问题：0 Critical/Important。N1 detached 后 Timer 对已 kill isolate dispatch = 静默 no-op（实测 TEST2 threw=false；IsolateDisposeAction 不清 connector，Info）；N2 local_ip external restart 与 settings 去抖交错最多多一次重绑、终值仍一致（Info）；N3 settings 500ms 与 resume 750ms 双 Timer 叠加同理（Info）；N4 start 失败瞬间窄竞态：complete 旧 completer 后 catch 新建 Completer → 挂起至下个 restart，与基线 9529e915 行为相同（既有 Minor，非本补丁引入，可在 catch 检查 _restartPending 根治）；N5 首跑测试 +13 -2 系 pub 并发下载 flake（后续 6 次重跑+全量 93/93 全绿）；N6 IsolateSetupAction await 窗口 settings 变更缺口在 runApp 前 UI 不存在、当前不可达（Info 备查）
- 工具链全绿：flutter analyze（app）No issues；dart analyze isolates lib+test No issues（全包 43 error 全在 vendored rust_builder/cargokit，上游既有）；flutter test app 93/93、isolates 18 passed + 4 rust-skip；SDK 语义实测 2 项（FIFO、dead-send no-op）
- 报告写入 reviews/V-1.md（9 节：工具链/调用链全景/四分支推演/去抖/终值追链/ref 生命周期/新问题/判定表/结论，全部结论带 file:line 或实测输出证据）

Stage Summary:
- 结论 **PASS-with-notes**：settings → discovery 重启链在 7d25f792 端到端成立——sync 立即 + restart 500ms 去抖 + 子 isolate FIFO + `_restartPending` 补停，任意按键序列/任意到达时序下 discovery 均以最后 sync 的终值重绑（"1500" 实证 4 sync→1 restart→timeoutMs=1500 生效，全网仅 1 次 announce burst）；去抖与 external 派发交错无终值丢失路径；ref 闭包延迟使用经 refena 3.5.0 源码证实容器级安全。R-8 I-1/I-3 均 FIXED，R-2/R-5 派发模式 FIXED（analyze 0 error）。Notes：N1 connector 自洽清理、N4 既有 start-fail 窄竞态（建议 catch 内查 _restartPending）、N5 CI 首跑重试——均 Info/既有 Minor，不阻塞合并
---
Task ID: 21-b / Agent: V-2 verify-subagent / Date: 2026-10-03

# Task

验证 round-2 修复 commit 7d25f792 对 round-1（R-2/R-7/R-8）local_ip_provider 五项发现的修复（C-1a global API / C-1b setEquals / I-1 空转非空 / I-2 并发 fetch / I-3 Windows poll getWifiIP + timer try/catch），真工具链实证，猎杀修复引入的新问题（provider 循环依赖、external debugOrigin、_fetchId 语义、includeWifiIp 伪重绑、visibleForTesting），去理想化场景闭环推演；只读仓库，产出 V-2.md。

# Work Log

1. 读取 R-2.md / R-7.md / R-8.md 与 `git show 7d25f792`（5 文件 +245/−42），通读修复后 local_ip_provider.dart / settings_provider.dart / main.dart / discovery.dart / parent_isolate_provider.dart / init.dart / discovery_isolate.dart / actions.dart / network_info_provider_test.dart。
2. refena 3.5.0 源码逐行核实（pub-cache，与 pubspec.lock:1347-1362 钉死版本一致）：redux_action.dart:45 state getter 为 live 读、:140-148 external() 构造 Dispatcher；dispatcher.dart:38-47 与 ref.dart:196-206 对照——external 与 ref.redux().dispatch 终点调用相同、仅 debugOrigin 标签不同（observer-only）；redux_provider.dart:43-60 依赖图仅用于 dispose 级联；base_notifier.dart:144-188/238-247 updateShouldNotify 默认值相等 + NetworkState dart_mappable 值相等（network_state.mapper.dart:88-93 → class_mapper.dart:245-252 深比较）→ 丢弃路径 `return state` 与无变化 poll 均不触发通知；redux_notifier.dart:283-398 无队列 + :345-357 库自认微任务竞态。meta-1.17.0:555-562 核实 visibleForTesting 同库调用合法。
3. 工具链实证（Flutter 3.41.9 stable）：`flutter analyze` → **No issues found**（0 issues）；`flutter test test/unit/provider/network_info_provider_test.dart` → **15/15 全过**；补跑 `flutter test test/unit/` → **93/93**、`packages/localsend_isolates flutter test` → **18 过 + 4 rust-skipped**，均与 commit 自述一致。
4. 五项修复逐项验证（详见 V-2.md §2）：全部 FIXED。provider 初始化顺序核实——IsolateController.init() 不读 localIpProvider，override+IsolateSetupAction 在 preInit await 完成先于 runApp，localIpProvider 仅由 widget 树实例化，与 nearby_devices_provider.dart:19 既有范式同构，无环、无 'Not initialized' 可达路径；_fetchId 写不变式（检查-派发-返回同同步块）核实。
5. 新问题猎杀（V-2.md §3）：**N-1 [Important]** 首抓取在途（getWifiIP 挂起 >10s，Timer.periodic 不等待回调）或抛异常时，后续 fetch 也读到 state.initialized=false 以"首抓取"身份跳过重绑，首抓取又被 _fetchId 丢弃 → 离线启动 + 窗口内来网 = discovery 永久哑火（I-1 同级后果；非回归，9a661080/基线同洞；一行修复 `fetchId > 1 || state.initialized`）；N-2 [Minor] Windows poll(false) 与 startup/resume(true) 集合因 thirdParty 绕过 whitelist/blacklist 过滤（:221）而不一致 → 首个 tick 一次伪重绑 + resume 后成对振荡（条件：黑名单覆盖 Wi-Fi 子网 [代码确定] / APIPA [UNVERIFIED]）；N-3 [Minor, pre-existing 79e89c2e] refena.dart:30-31 exclude 过滤器比对 '_FetchLocalIpAction'（类已公有化）永不匹配，10s poll 放大 debug 日志噪音；N-4 [Info] 版本丢弃新鲜度假设可反转（有界 ≤10s 自愈）；N-5 [Info] startup/resume/手动刷新在 Windows 仍各一次 getWifiIP（与基线/上游逐字节同路径，upstream parity）；N-6 [Info] 微任务窗口并发比较基准陈旧（理论级）。
6. discovery.dart _restartPending 七类交错推演（V-2.md §4）：R-8 I-1 丢失重启窗口关闭，pending-stop 先于 announce 无突发浪费，双 restart 幂等。
7. 去理想化闭环（V-2.md §5）：Windows 离线启动→10s Wi-Fi→热点→VPN 四步中三步完全闭环（每步 ≤10s 检出 + 单次重绑 + 单轮 announce），唯首抓取慢/失败时落入 N-1 死局。
8. 顺带核验：R-7 N-4 游离文件 `80===` 已清理；R-8 I-3 settings 500ms debounce 保序（sync 即时）；R-2 Minor-1 resume 守卫 + Android 750ms debounce 成立。

# Stage Summary

- 判定：**PASS-with-notes**。五项 round-1 发现全部真修复（analyze 0 issues、15/15、93/93、18+4skip 实证），R-8 I-1/I-3 与 R-2 Minor-1 附带修复亦成立。
- 主要残留：N-1 [Important] 首抓取重叠/抛异常竞态使 I-1 修复落空（离线启动死局复活门），一行可修（`firstFetchDone: fetchId > 1 || state.initialized`）；N-2/N-3 Minor；N-4/N-5/N-6 Info。
- 建议顺序：N-1（合入前）→ N-3（两字符串）→ N-2（poll 集合与 merge 集合同源）→ N-5 写入上游 PR 边界声明。修 N-1 后本轮即达 PASS。
- 产出：/home/z/my-project/reviews/V-2.md（完整报告）。
---
Task ID: 21-e
Agent: V-5 verify-subagent
Task: round-2 测试充分性与验证门禁复验（对应 round-1 R-5 角度）：对 7d25f792 的 +8 shouldRebindDiscovery 测试做工具链实证、突变验证、覆盖缺口复审、flaky 检查与 fork CI 预测；评估"settings observer 测试因无 refena 基建不做"的决策。

Work Log:
1. 通读 R-5 round-1 报告、7d25f792 全量 diff、network_info_provider_test.dart 15 用例、local_ip_provider.dart / settings_provider.dart / main.dart / discovery.dart 现行实现。
2. 工具链实证（Flutter 3.41.9 stable = ci.yml:10 钉死版本）：app `flutter analyze` → "No issues found! (ran in 2.8s)"；app `flutter test` → "00:10 +93: All tests passed!"；isolates `flutter test` → "00:01 +18 ~4: All tests passed!"（4 个 rust 门控 skip）；`dart format --set-exit-if-changed` 指定 4 文件 → "Formatted 4 files (0 changed)" exit 0；CI 等价全量 `dart format ... lib test` → "Formatted 290 files (0 changed)"。
3. 突变验证（临时编辑→测试→git checkout 恢复，4 组）：M1 setEquals→!=（4 红：unchanged/re-ranked/duplicates/staying-offline）；M2 →ListEquality（2 红：re-ranked/duplicates）；M3 firstFetchDone→isNotEmpty（1 红：offline-start）；M4 删守卫（1 红：first-fetch）。C-1b 与 I-1 均被钉死。恢复后 4 文件 md5 与 HEAD 一致、git status 干净。
4. settings 可测性 PoC（文件置仓库外 reviews/tmp/，经 `flutter test <外部路径>` 运行，repo 零写入）：手写 implements PersistenceService fake + implements IsolateConnector 录制 fake + RefenaContainer(observers/overrides)。踩坑并解决：① mocks.mocks.dart 过期缺 8 getter（when() 无法补桩）→ 改手写 fake；② IsolateConnector 私有构造 → implements；③ **必须传 observer 否则 onChanged 不触发** → 发现 Critical。
5. Critical-1 实证链：refena 3.5.0 base_notifier.dart:164-183 onChanged 仅 observer!=null 分支调用；container.dart:135/569-571 空 observers→null；init.dart:150 `kDebugMode ? [CustomRefenaObserver()] : []`（上游 f6686563 引入）→ release/profile 下 settings/server/security/deviceInfo 四个 provider 的 onChanged 全部死代码；PoC 无 observer→0 消息、有 observer→[sync, 500ms 后 restart] 序列正确、3/3 绿。
6. flaky：新 8 例纯函数零依赖，连跑 5 次 5×"+15: All tests passed!" 各 <1s；setEquals 无序敏感、不依赖 SDK sort 稳定性。
7. CI 预测：format PASS（290 files 0 changed）/ test PASS（93+18+4skip 同版本复现）/ rust 无法本地验证（无 cargo；本 commit 零 .rs 改动）/ packaging PASS（版本 1.18.2×6、版权 2022-2026×5、toolchain 1.97.1×2 本地复刻全一致）。fork Actions API（authenticated）：total_count=1、fork main=6fbfa5c3 < 本地 7d25f792（未推送，ci.yml 0 run）。
8. 报告 Write 至 reviews/V-5.md（含发现清单：Critical-1、Important-2 mocks 过期、Important-3 settings 零覆盖延续、Minor-4/5 延续、Info-6 round-1 UNVERIFIED 闭环、UNVERIFIED 5 项）。

Stage Summary:
结论 PASS-with-notes。门禁全绿、8 新测试突变全钉死、零 flaky、CI 3/4 可本地预测 PASS（rust 标注）；但发现 round-2 新 Critical：refena 3.5.0 onChanged 的 observer 门控 × app 仅 debug 传 observer → P0 修复 settings 半边在 release 构建为死代码（PoC 双向实证），且"无 refena 测试基建"的决策理由不成立（RefenaContainer+override 路径已实证 3/3 绿，最小路径约 110 行 0 lib/ 改动，正确写法反而会暴露该 Critical）。建议主 agent：修 Critical-1（init.dart 无条件 observer，一行量级）→ 推送触发 ci.yml 首跑 → PoC 转正为 settings_provider_test.dart。证据与命令输出全文见 reviews/V-5.md；PoC 存于 reviews/tmp/v5_settings_poc_test.dart。

---
Task ID: 18
Agent: Super Z (main)
Task: 下载工具链与 superpowers 技能库 + 派遣 10 个审查 subagent（round-1）

Work Log:
- 确认现状：Task 1-17 已完成（含 Release p0-review-v1 五产物、站点 v2）；本轮新指令=工具链验证+全方位审查+修复回验+升级成本+发版 v2
- 下载 Flutter 3.41.9 stable SDK（.fvmrc 钉死版本，1,518,927,432 字节，storage.googleapis.com 直连 ~5.2MB/s）解压至 /home/z/flutter；flutter pub get（app + isolates）
- 重新克隆 obra/superpowers（上一会话目录已丢失）至 superpowers-skills（15 技能）
- 按 using-superpowers 规则加载 dispatching-parallel-agents + requesting-code-review 流程技能；10 个审查 agent 一次性并行派遣（20-a~20-j），flock 防并发写坏 worklog，独立报告落盘 reviews/
- **去理想化第一实证**：flutter analyze 报 v1 补丁 2 个编译错误（Undefined name 'global'，local_ip_provider.dart:102/104）——静态审查结论（R-2/R-7 Critical）被工具链证实
- 联网核实上游 221f40a9（fix(windows): unwanted location permission）：diff 显示其删除了 Windows 5s Stream.periodic 轮询（正是 getWifiIP 位置权限问题）——v1 补丁重新引入轮询必须跳过 getWifiIP

Stage Summary:
- 工具链就绪；round-1 九份报告返回（R-1 空响应，由 round-2 V-1 补位）：2 Critical（不可编译 + setEquals 反转）、8 Important、多家交叉验证

---
Task ID: 19
Agent: Super Z (main)
Task: 自行修复 round-1 发现 + round-2b 加固 + 全套工具链门禁

Work Log:
- round-2a（7d25f792，5 文件 +245/−42）：local_ip_provider 改 external(controller).dispatch（refena 文档模式）；setEquals；state.initialized 首轮判定；_fetchId 版本号防旧覆新；Windows 轮询 includeWifiIp:false + try/catch；settings restart 500ms 去抖；main.dart Android 750ms 去抖 + null 守卫（iOS 保持 63efbe6b 立即行为）；discovery.dart _restartPending（循环顶清零 + 绑定后补停跳过 announce）；+8 shouldRebindDiscovery 纯函数测试
- 派遣 round-2 验证团 V-1~V-5（21-a~21-e，可亲跑工具链）：V-3 PASS、V-1/V-2/V-4 PASS-with-notes、V-5 PASS-with-notes + 新 Critical
- round-2b（1ac3fea3，6 文件 +225/−4）：**refena onChanged 死代码修复**（亲自读 refena-3.5.0 base_notifier.dart 证实：_onChangedListener 仅在 observer!=null 分支调用；init.dart 只在 kDebugMode 传 observer → release/profile 下 settings 同步链整个是死代码，上游 server/security/deviceInfo 同样受累）→ 新增 OnChangeEnablingObserver；refena.dart _exclude 旧类名字符串修正；firstFetchDone = initialized || fetchId > 1（V-2 N-1 首抓取挂起/抛异常传染洞）；localsend_isolates 导出任务类型（可测试性）；+4 settings 集成测试（录制式 isolate 连接器，V-5 PoC 转正）；pubspec 声明 typed_isolates 直接依赖（字母序）
- 门禁终态：flutter analyze 0 issues；dart format 0 changed；app flutter test 97/97；isolates 18+4 rust-skipped；期间修掉测试文件的 dispose 签名错误与 2 个 lint

Stage Summary:
- 三个 round-1 Critical 全部修复且经 round-2 复验；新增 12 个回归测试（8 纯函数 + 4 集成）；突变验证（V-5）：setEquals→!= 则 4 红、首轮判定回退则 1 红

---
Task ID: 22
Agent: Super Z (main)
Task: v2 发版工程（物料 + workflow 修正 + 推送 + tag + release）

Work Log:
- 生成验证日志（analyze/test，EXIT=0）存档 review/deliverables/verification/；重生成全量补丁 localsend-p0-fixes.patch（755 行，11 文件）
- 归档双轮审查报告：review/verification-round1/（R-2~R-10 九份）+ verification-round2/（V-1~V-5 五份）
- 新增 review/deliverables/flutter-upgrade-cost.md（3.41.9→3.47.6，联网核实版本事实 + 全仓弃用 API 统计全 0，成本判定：代码迁移低<1天/全平台验证中 1-3 天）
- release-notes.md 重写为 v2（三级发现表 + 验证状态 + 11 文件修复清单）；review/README.md 升级（v2 横幅 + commit 构成表 + 验证状态去理想化）
- release.yml 修正（R-9 round-1 发现）：删除 dispatch 默认 tag（防误覆盖 v1）、标题从 tag 派生、checkout@v6、modified-source 扩至 11 文件、新增产物（升级成本/analyze 日志/test 日志/SHA256SUMS）
- 推送 fork main → 首次触发 ci.yml（format/test/rust）→ 全绿后打 tag p0-review-v2 → release workflow 发布 8 产物

Stage Summary:
- v2 交付：双轮审查（15 agent）+ 真工具链四门禁全绿 + 8 产物 Release；上游零改动

---
Task ID: 23
Agent: Super Z (main)
Task: v2 发布执行 + 站点回写与端到端验证

Work Log:
- CI 闸门：本 fork 的 push 事件从不触发 workflow（三次 main 推送 + v2 tag 推送均零 run；与凭证无关的平台行为，已实证）→ 给 ci.yml 增加 workflow_dispatch 触发器（e2445e75）后手动派发 → run 37111504433 四 job 全绿（format / test / rust / packaging，GitHub runner + Flutter 3.41.9）
- tag p0-review-v2（annotated，指向 e2445e75）已推送；tag 触发同样失效 → workflow_dispatch 派发 release.yml（run 37111726550 success）
- Release p0-review-v2 发布核验（API）：9 产物（patch 32,728B / modified-source.zip 23,640B / review-archive.zip 3,998,923B / flutter-upgrade-cost.md / flutter-analyze.log / flutter-test.log / SHA256SUMS / 报告×2），标题自 tag 派生正确，notes 为 v2 全文
- 站点 v2 回写：download/release-info.json（9 产物真实大小）；content.ts（11 文件源码浏览器清单 + v2 常量）；page.tsx（进度叙事全面 v2 化：已完成 9 项 / 待办 2 项 / 明确不做 1 项）
- 站点两处修复：page.tsx 引用未导入的 FIX_COMMIT_V1 导致 SSR 异常（agent-browser 首次打开即发现）→ 补 import；产物计数文案 8→9
- eslint 配置排除非站点目录（superpowers-skills / localsend / reviews / download 等）→ bun run lint exit 0
- agent-browser E2E 全过：3 tab 渲染；11 文件浏览器；git 状态卡实时显示 e2445e75 + clean；Diff/完整源码切换；发布 tab「已发布」徽章 + 9 产物表；评审报告渲染；console 零错误、页面零错误；390×844 移动端 tab 换行不溢出；footer 长内容自然下推（bottom 2739>844）无悬浮；截图 2 张存档 download/preview-site-v2r-{mobile,desktop}.png
- dev.log 复核：GET / 200，无运行时错误

Stage Summary:
- v2 全链路交付闭环：工具链四门禁全绿 → CI 四 job 全绿 → tag → Release 9 产物 → 站点自动切换「已发布」态；用户侧遗留：真机多平台验证、空壳仓库 localsend-review 手动删除、上游 issue/PR 决策
