# LocalSend 缺陷与社区痛点调研报告（Task 36-a / RESEARCH-A）

- 调研日期：2026-10-03（UTC）
- 调研对象：上游 localsend/localsend（fork 基线 9529e915，app 1.18.2+64，分支 radical/conservative）
- 目的：为 fork 后期 TODO 提供有依据、按可行程度排序的候选清单

---

## 1. 调研方法与来源清单

### 1.1 方法
1. `git -C /home/z/my-project/localsend fetch origin`（只读，FETCH_HEAD 时间戳 2026-10-03 16:10 UTC，确认数据新鲜）+ `git log --oneline 9529e915..origin/main`、`git log --oneline v1.18.2..9529e915`、`git tag`。
2. GitHub REST API（curl + fork remote 内置 token，共约 60 次请求）：
   - 开放 issue 按评论数 Top50：`/issues?state=open&sort=comments&direction=desc&per_page=50`
   - 最新开放 issue 60 条：`/issues?state=open&sort=created&direction=desc&per_page=60`
   - 38 个重点 issue 详情（含 8 组评论、1 组 timeline）、releases、roadmap #345、仓库统计
   - 搜索：`proxy in:title`、`1.18 in:title`、`label:bug sort:reactions`、`label:bug/networking` 计数、`discover/transfer/crash` 关键词计数
3. Web 搜索（Skill: web-search，z-ai CLI `web_search`，10+ 轮英文查询），命中的社区来源：
   - Reddit r/androidapps：「LocalSend can't detect PC on Android」（reddit.com/r/androidapps/comments/1kycnqk，snippet：“Made sure both devices are on the same network…Syncthing is the solution!”）
   - superuser.com/questions/1918988（iPhone↔laptop 偶发互相看不见；官方排查建议 AP 隔离）
   - forum.qubes-os.org/t/localsend/23774（Flatpak 下互相不可见）
   - windowsforum.com（Win 下探测不到设备的排查指南，2025-03）
   - taptu.com/t/2605「What has been your biggest issue with LocalSend so far?」（2026-05：防火墙与 VPN 是最常见原因）
   - portablefreeware.com（2023：Android⇄Windows 传输多数失败）
   - idroot.us（2025：教程类，要求路由器开 multicast）
4. `curl https://localsend.org/changelog`（HTML 提取 v1.18.x 全部条目）。
5. Reddit JSON API（old.reddit.com/.json）被反爬拦截（返回 "Blocked" HTML），已记录为局限；Reddit 证据以 web 搜索 snippet 兜底。
6. 本仓库代码只读核对（rg/git show）以确定修复落点与可行度。

### 1.2 仓库现状（2026-10-03 实测）
- 93,259 stars / 5,215 forks / **1,093 open issues+PRs**（API `/repos/localsend/localsend`）
- 开放 label:bug **284**；标题含 transfer **94**；正文含 discover **60**；标题含 crash **25**（search API 计数）
- 最新 release：**v1.18.2（2026-08-21）**，无更新版本；origin/main HEAD == 9529e915（即我们的基线，**无新提交**）

---

## 2. 缺陷/痛点清单（证据 → 症状 → 根因 → 评级 → 修复落点）

> 评级标准（按任务要求）：**High** = 纯 Dart 侧，flutter analyze + flutter test 门禁可完全验证，不碰协议；**Medium** = Dart 侧但改动面大/风险高，或需要 build_runner/平台配置而无法运行时验证；**Low** = 需 Rust/FRB 改动（本环境无 cargo）、真机/硬件、或改官方 v2 协议。

### A. 发现/连接类

**A1. 服务器绑定失败的用户体验极差（Windows errno 10013 家族）**
- 证据：#125（open，59 评论，22👍，2023-02 起）「Socket Exception (Forbidden access)」；#2884（open，11c，7👍，2025-12）「Windows socket error (errno 10013) on default port 53317 prevents app from starting」；#2746（open，22c，4👍，2025-10）；#846（open，10c，2023）
- 症状：Windows 启动即报 `SocketException ... errno = 10013, port = 53317`，防火墙关闭、管理员权限均无效
- 已知根因（issue 评论）：Hyper-V/WSL/Docker 的**排除端口段**占住 53317（Lavoltz：装 Docker/WSL2 复现）、Winsock 损坏（`netsh winsock reset` 可修，codeStruggle/gilbertfl 验证）；改端口（54000）可绕过（rpaulbeck）
- 评级：**High**——纯 Dart：`app/lib/config/init.dart:223-229` 目前只把 `e.toString()` 丢进 snackbar；可识别 SocketException/errno → 弹可操作对话框（提示排除端口段、换端口、netsh、防火墙清单），逻辑可单测
- 建议落点：`init.dart` 启动 catch 分支 + 新错误对话框组件 + `t`（en.json）文案；可选联动 troubleshoot 页

**A2. 手动发送对话框无输入校验、不支持 IPv6 字面量（#549 局部）**
- 证据：#549（open，16c，**37👍 全场最高**）「Feature request: Support IPv6」——body：输入 IPv6 地址或仅有 AAAA 的域名显示 "error"
- 症状：手动 IP 模式输入 IPv6（如 `fe80::1`）失败；垃圾输入也直接发 HTTP 请求
- 已知根因：`app/lib/widget/dialogs/address_input_dialog.dart` 无 `InternetAddress.tryParse` 校验；`ipPrefix` 扩展按 `.` 切分（IPv6 无效）；`api_route_builder.dart target()` 用 `Uri(host:)` 可自动加方括号但上游从未接通 IPv6 输入路径。注：Rust 服务器已双栈绑定（`packages/core/src/http/server/mod.rs:234-245`），手动 IPv6 端到端链路只差 Dart 输入/规范化
- 评级：**High**（输入校验/规范化/错误提示完全可单测；真实 IPv6 网络下的端到端验证属于加分项而非门禁）
- 建议落点：`address_input_dialog.dart`（校验 + IPv6 归一化 + 示例文案）、`send_tab_vm.dart onTapAddress`；不改 `api_route_builder` 语义
- 边界：**完整 IPv6 发现**（IPv6 multicast 宣告）= v2 协议改动 → 排除，见 §4

**A3. 收藏/手动连接失败的原始异常直出（#2121）**
- 证据：#2121（open，15c，2👍，2024-12）「RhttpTimeoutException: Request timed out」——收藏按钮旁的 ⓘ 展示 `[RhttpTimeoutException] Request timed out. URL: https://.../info`
- 已知根因：对端离线/防火墙（评论区：Win 防火墙 public profile、macOS 防火墙未关联 LocalSend 流量，Tienisto 亦确认）；UI 把 `e.toString()` 原文塞进 ErrorDialog（`address_input_dialog.dart:89`、`send_tab_vm.dart` 收藏流程同款）
- 评级：**High**——错误分类映射（timeout/refused/forbidden → 友好文案 + 重试按钮 + 排查建议）纯 Dart 可测
- 建议落点：`address_input_dialog.dart` / `FavoritesDialog` 共用错误映射工具（新 util + 单测）

**A4. 发现空列表缺少"手动收藏/IP 变动"引导（#3319、#527 生态）**
- 证据：#3319（open，11c，2026-08）：v1.18 移除 hashtag 后 iPad 不被发现、用户找不到 Verify；维护者建议"add the devices to favorites"，用户回"but my ip changes"；#527（open，20c）发现类元 issue（AP 隔离/热点需重启/子网过大）
- 评级：**High**——我们已有 `DiscoveryEmptyState`（f0289e5d 三层诊断），补第 4 层引导 CTA（"IP 常变？加入收藏/手动输入"）纯 UI
- 建议落点：`app/lib/widget/discovery_empty_state.dart`（或 send_tab 空状态区）+ en.json

**A5. VPN/Tailscale 网络下发现不到设备（#1598、#1123）**
- 证据：#1598（open，23c，7👍，2024-07）「Cannot discover other devices on VPN」；#1123（open，12c，2023-12）「Support Tailscale detection」
- 已知根因：tun 接口默认不参与 multicast/被接口截断逻辑排除；#3391（Mullvad VPN 放行 LAN 也不行）同族
- 评级：**Medium**——扫描接口集合逻辑在 isolate 侧 Dart（`scan_facade.dart`/`local_ip_provider.dart`，我们已做 maxInterfaces 配置化，模式可复制），但本环境无 VPN/tun 可运行时验证，风险在真实网络
- 建议落点：settings 增"Include VPN interfaces"开关 → `scan_facade.dart` 接口过滤参数化 + `constants.dart`/`settings_provider.dart`（照 maxInterfaces 模板）

**A6. Windows 热点场景选错 IPv6 导致偶发互不可见（#3509，今日新报）**
- 证据：#3509（open，2026-10-03，1.18.2+64）：Windows 自带热点仅 IPv4，LocalSend 却用 IPv6，重启应用后恢复
- 已知根因：本地 IP/接口排序未考虑"对端网络族"；上游 2023-02 有未合并草稿分支 `origin/feature/improve-local-ip-ranking`（bc472471，按接口名打分：热点>wifi>未识别），可作参考证据
- 评级：**Medium**——排序逻辑在 isolate/Dart 侧，但需要真实热点环境验证，盲改风险高
- 建议落点：`packages/localsend_isolates/lib/.../local_ip_provider`（isolate 侧 IP 排序）+ 诊断日志先落地观察

**A7. 子网大于 /24 时 IP 扫描失效（#525）**
- 证据：#525（open，7c，2023-06，汇总 #175/#199/#201/#221）「Cannot discover when subnet is larger than /24」——multicast 不可用时回退 IP 扫描只支持 /24
- 评级：**Medium**——`scan_facade.dart` legacy 扫描逻辑 Dart 可改可测（枚举 IP 列表），但大子网全扫资源密集，需要限流/并发控制设计，改动面与风险偏大
- 建议落点：legacy scan（send_tab.dart:353 手动选子网路径）+ `constants.dart` 扫描上限

### B. 传输类

**B1. 大批量/大文件夹传输的失败文件恢复难（#3418）**
- 证据：#3418（open，fr，2026-09-10）「Better handling of large folders (50GB+) and failed files」——307 个文件挂 7 个，恢复只能整夹重传
- 上游动向：PR #3462（open，2026-09-26）「fix: allow retrying interrupted files in an existing transfer」正在做同款修复（接收端保留失败文件的目标路径、放行手动重试）
- 评级：**Medium**——send/receive controller（`app/lib/provider/network/server/controller/*`、`file_transfer_provider.dart`）Dart 侧可测，但会话状态机改动面大，且应先观察上游 PR 落地形态避免分叉
- 建议落点：接收端会话保留策略 + 发送端 per-file retry 放行

**B2. 传向 Android 速度仅 ~5 MB/s（#1090）与大文件中途停止（#1597）**
- 证据：#1090（open，11c，2024-01）；#1597（open，9c，2024-07，标签 windows+android）
- 已知根因（评论）：#1597 用户关加密后解决且大幅提速；维护者 Tienisto 怀疑 **Android content URI 不如直文件系统稳定**；#1090 用户切 Wi-Fi 开关后到 100MB/s（手机省电机制）。v1.18.0 changelog 已含 "faster transfers for slow receiving devices"（read-ahead 收敛，e10e6250 在基线内）
- 评级：**Low**——根治点在 Rust 侧读取管线（content URI 流式化）与真机网络环境，flutter test 无法验证
- fork 可做的只有：诊断信息增强（记录断流时刻的 socket 错误）→ 可并入 B1/诊断类

**B3. Android→Mac 部分文件失败/损坏但报告成功（#3441）；校验和计算崩溃（#3425）**
- 证据：#3441（open，2026-09-16，双端 1.18.2）；#3425（open，needs-more-info，2026-09-12）
- 评级：**Low**——数据完整性取证需真机 + 抓包；#3425 需更多信息；注意 v1.18.0 起默认开校验和（changelog），基线内还有 "fail the transfer when a file cannot be read instead of sending an empty body"（5db88c63）属同域修复
- 建议：先在 fork 的传输完成页展示"校验和已验证/未启用"状态（High，纯 UI）作为低成本缓解

**B4. iOS 多文件分享不可靠（#1268）**
- 证据：#1268（open，3👍，12c，2024-04 起）——400 张照片分享后 app 不再打开；2026-06 评论：99 张只收到 80 张（web 接收端），怀疑并行传输丢文件
- 评级：**Low**——iOS Share Extension 内存上限 + 真机验证；Dart 侧逻辑（顺序发送开关）可做但无法验证效果

### C. 平台特有/桌面集成类

**C1. Autostart 失效（#1927，17👍；#3064）**
- 证据：#1927（open，15c，17👍，2024-10）Linux 自启被重置；#3064（3👍，2026-05）Flatpak 自启不保存；#3421（2026-09）同类
- 评级：**Medium**——`launch_at_startup`/桌面文件属平台配置，Dart 侧可改但本环境无 GUI 无法验证；社区价值高（17👍 为 bug 类第 2）
- 落点：`app/lib/provider/.../autostart`（settings 联动）+ Linux .desktop 安装脚本

**C2. Linux 桌面集成杂症（托盘/图标/主题）**
- 证据：#2902（3👍，2026-01）每次重启生成新托盘图标；#3484（标签 *awaiting flutter upgrade*，2026-09）托盘显示 `org.localsend.localsend_app`；#3413/#3416（2026-09）Wayland/KDE 任务栏图标缺失；#2241（4👍）KDE 标题栏暗色模式
- 评级：**Low**——上游已标注等待 Flutter 升级；无 GUI 环境不可验证
- C2'. **Linux --hidden 启动后无法接收（#3055，10c）**：评级 **Medium**（Dart 生命周期逻辑，但需桌面环境验证）

**C3. Windows 10 下 1.18.2 无法启动（#3456）**
- 证据：#3456（open，2026-09-22，Win10 19045，"The request is not supported"）
- 评级：**Low**——需 Windows 真机；疑工具链/系统 API 版本问题

**C4. Xiaomi HyperOS 3 文件选择器 NoPermissionDialog（#3065，4👍）**
- 证据：#3065（open，2026-05）；相关 #3459「Use system photo picker」+ 上游分支 `origin/use-native-media-picker`
- 评级：**Medium**——换 picker 依赖属 Dart 侧，但必须真机回归

**C5. iOS Share Sheet 被上次 Finished 屏阻塞（#3197，3👍）**
- 证据：#3197（open，2026-07-18）——不点 Done 再分享第二张照片会卡在旧结果页
- 评级：**Medium**——app 层路由/状态重置逻辑简单，flutter test 可覆盖状态机，但 iOS Share Sheet 入口行为需真机确认

**C6. iOS 缓存持续膨胀且无法清理（#2926，2👍）**
- 证据：#2926（open，2026-02）
- 现状：app 启动已有 `ClearCacheAction`（init.dart:307-309 + cache_helper.dart，清 temporary 目录），膨胀源不在该路径（疑 iOS 扩展/引擎缓存）
- 评级：**Low-Medium**——可加"设置→清除缓存"手动入口（High 可施工），但根治需 iOS 设备定位膨胀源

### D. 功能诉求类（社区高票）

**D1. Android 后台常驻接收（#2153，32👍；#1468 iOS，11c）**
- 证据：#2153（open，16c，32👍）「run in the Background on Android」；上游 PR #3471（2026-09-28）「background receiving controls and actionable transfer requests」正在实施同款
- 评级：**Low**（自研）——前台服务 + 平台通道 + 真机；建议跟踪 #3471 落地后评估 cherry-pick
**D2. 发送后可选删除源文件（#1918，9c）**：**Medium**——send controller 成功回调 + 设置项 + i18n，纯 Dart 可测；涉及删数据需二次确认 UI
**D3. 队列/完成分栏（#3438）**：**Medium**——UI 重构面大，社区票数低

---

## 3. Top 10 候选 TODO 总排序表（可行度 × 社区价值）

| # | 事项 | 证据（👍/评论） | 可行度 | 一句话理由 |
|---|------|----------------|--------|-----------|
| 1 | 服务器绑定失败 → 可操作错误对话框（10013 家族） | #125 22👍/59c、#2884 7👍、#2746 22c | **High** | init.dart:227 仅 snackbar 原文；错误分类+指引纯 Dart 可单测 |
| 2 | 手动发送输入校验 + IPv6 字面量支持 | #549 **37👍**（全场最高） | **High** | address_input_dialog 无校验；Rust 端已双栈，只差 Dart 输入链路 |
| 3 | 收藏/手动连接超时错误友好化 + 重试 | #2121 15c | **High** | `e.toString()` 直出 ErrorDialog；映射为文案+按钮可测 |
| 4 | 空设备列表加"收藏/手动输入"引导 CTA | #3319 11c、#527 20c | **High** | 扩展我们已有的 DiscoveryEmptyState，纯 UI+i18n |
| 5 | 传输完成页展示校验和验证状态 | #3441、#3425（缓解型） | **High** | 纯 UI 状态展示，为完整性争议提供可见证据 |
| 6 | 失败文件重试/会话保留 | #3418、上游 PR #3462 | **Medium** | 状态机改动面大；先观察上游 PR 形态 |
| 7 | 智能扫描纳入 VPN/tun 接口开关 | #1598 7👍/23c、#1123 12c | **Medium** | 照 maxInterfaces 模板可施工，但无 VPN 环境验证 |
| 8 | 热点场景 IPv4 优先的本地 IP 排序 | #3509（2026-10-03 新报） | **Medium** | 排序逻辑 Dart 侧，需真实热点验证；有上游 2023 未合并草稿可参考 |
| 9 | iOS Share Sheet 卡旧结果屏修复 | #3197 3👍 | **Medium** | 状态重置逻辑可测，入口行为需真机 |
| 10 | 子网 > /24 的扫描范围/诊断增强 | #525 7c | **Medium** | legacy 扫描 Dart 可改，但需限流设计+真实大子网验证 |

（次选池：#1918 发送后删源文件 Medium、#1927 autostart 17👍 Medium、#3055 --hidden 接收 Medium、C6 手动清缓存入口 High）

---

## 4. 明确排除项（不可行 + 原因）

| 事项 | 证据 | 排除原因 |
|------|------|---------|
| QUIC 传输层 | PR #3102（open，14c，实验性） | Rust 大改（FRB + jni），本环境无 cargo；协议演进方向 |
| 完整 IPv6 发现（IPv6 multicast 宣告） | #549 | 改官方 v2 协议（协议规定 IPv4 multicast 224.0.0.167:53317） |
| Web 客户端传输不启动 | #2951（18c） | web.localsend.org 不在本仓库（localsend/localsend 无 web 客户端代码，`git ls-files` 已核）；属独立项目 |
| CLI 接收文件夹丢目录结构 | #3503（自 #3344） | `cli/` 为 Rust 项目（Cargo.toml + src/*.rs），无 cargo 不可改 |
| Android/iOS 后台常驻自研 | #2153 32👍、#1468 | 前台服务/平台通道 + 真机；等上游 PR #3471 落地再评估 |
| 32 位 Android 崩溃 | #2562 | Rust so 的 ABI 问题，需 Rust 工具链 |
| Win10 1.18.2 启动失败 | #3456 | 需 Windows 真机取证 |
| 传输速度 5 MB/s 根治 | #1090/#1597 | 根因在 Rust 读取管线（content URI 流式）+ 手机省电环境因素；v1.18 已做 read-ahead 优化 |
| 大文件中途断流根治 | #1597 | 同上（维护者：Android content URI 稳定性疑点），需真机 |
| 蓝牙发现/传输 | #850 27c、#144 15c | 新传输层（协议+Rust+权限），超 fork 范围 |
| Live Photo 跨平台保真 | #3479、PR #2488 | iOS 真机 + 上游 PR in flight，避免撞车 |
| Linux 托盘/图标/主题族 | #2902/#3484/#3413/#3416/#2241 | 上游标 awaiting flutter upgrade；无 GUI 环境验证 |
| 校验和崩溃取证 | #3425 | needs-more-info + 需 Android 真机 logcat |
| #2007 重发同名文件失败 / #2985 Arch 接收失败 / #3441 损坏取证 | 见 §2 | 根因未明，需对应真机环境，先观察上游 |

---

## 5. 上游动态（9529e915 之后）

1. **零新提交**：`git fetch origin` 后 `git log 9529e915..origin/main` 为空，origin/main HEAD == 9529e915（基线即最新）→ **与 fork 两分支无任何重叠或冲突**；我们的 PR 候选分支（android-multicast-lock / fix-restart-discovery-on-settings-change）所涉区域上游近期未动。
2. **无新版本**：最新 release 仍为 v1.18.2（2026-08-21）；roadmap #345 仅剩 "v2.0.0 UI redesign (#300)" 未勾。
3. **基线领先 v1.18.2 共 52 commits**（`git rev-list --count v1.18.2..9529e915` = 52，即 v1.19 候选内容），要点：PIN 特殊字符修复（82abda32）、接收目录名冲突（f9b0e361）、Android SAF 保留文件名（3a79b003）、无法识别扩展名打不开（033d9751）、CLI 快捷键（22d02dd3）、Enter 确认改名（39584ae2）、按 IP 限流（612aef2）、减小文件流 read-ahead（e10e6250）、不可读文件改为失败而非发空 body（5db88c63）、系统日期格式（9529e915 本身）等。changelog "Unreleased" 仅新增 macOS Share Extension DMG 修复（3e8d76a5，已在基线）。
4. **与我们已有修复的关系**：
   - v1.18.2 已含「ignore proxies」（d99988eb，Rust `no_proxy`，修 #2552/#3285 家族）与「自动重启 HTTP/multicast server」——均在基线内，fork 自动继承，**不与**我们 P0 发现修复、MulticastLock、maxInterfaces、三层诊断、批量传输性能（d19fc88b/f0289e5d）重叠。
   - v1.18.0 的 "receiving/sending many files no longer freeze/lag"（上游多线程 #491 一系）与我们 #489 批量工作（进度通知节流 + 目录枚举移出主 isolate）**互补不重复**：上游解决传输线程/read-ahead，我们解决主 isolate 卡顿与 UI 通知风暴。
   - 需盯防的 in-flight PR：#3462（失败文件重试，撞 Top10#6）、#3471（后台接收控制，撞 #2153/#1468）、#3102（QUIC）、#2488（Live Photo）、#3453（主题色强度）。若上游合入，fork 应以 cherry-pick 优先。
5. **维护者结构变化**：ShlomoCode 2025-10 起活跃参与 triage/关闭（#2552/#2367 评论可证），Tienisto 仍是核心；issue 模板 0f78d8d1 起强制要求 app 版本——fork 复盘社区报告时可按版本过滤。

---

## 6. 局限声明

- Reddit 站内 JSON 被反爬拦截，社区论坛证据以 web 搜索 snippet 为准（标题+摘要，未逐帖全文核验）。
- GitHub API 数据截至 2026-10-03 16:10-16:40 UTC；issue 👍/评论数随时变化。
- 所有"可行度"评级基于本沙箱能力（flutter analyze/test 门禁、无 cargo/无 GUI/无真机），非对修复价值的否定。
