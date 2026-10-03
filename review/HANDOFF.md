> **状态更新（2026-10-03 v3）**：本文件是交接包时期的历史档案，描述以 zip 为载体的恢复流程。
> 当前持久化终态已迁移：评审存档位于本 fork `main` 分支 `review/` 目录；P0 修复经 PR #1 合并进 main；
> 发布产物见 Release `p0-review-v1`；远端分支 `review-docs` / `p0-discovery-fixes` 已删除。
> 文内"重建/恢复"指令仅在未来环境再次丢失时才需要执行。

# HANDOFF — LocalSend 传输链路优化报告评审项目 · 交接包 v2（适配全新重置环境）

> 打包时间：2026-10-03（UTC+8）｜交接人：Super Z（主 agent）｜状态：**主链路 100% 完成**
> 适用场景：**全新重置后的环境**——工作区为空，本 zip 是唯一存活的资产。解压本包 + 重克隆仓库即可恢复 100% 工作状态。

---

## 0. 一句话状态

对用户上传的《LocalSend 传输链路优化总报告》（行号级源码分析报告）完成了「克隆源码 → 逐条核查 79 处引用 → 5 视角 subagent 评审团反审查（43 条意见）→ 评审报告 v2 定稿 → P0 代码修复（5 文件 +83/−6 行）→ Next.js 交付站点」的完整闭环。剩余工作（跑 Flutter 测试、上游 issue/PR）全部需要真实工具链或 GitHub 交互。

---

## 1. 环境恢复（新会话第一件事，按顺序强制执行）

1. **定位本包**：若 `/home/z/my-project/download/` 下有 `localsend-review-handoff-20261003.zip` 直接用；若重置后 download/ 也为空，请用户重新上传该 zip（会出现在 `/home/z/my-project/upload/`）。
2. **解压恢复工作区**（在 `/home/z/my-project/` 下执行）：
   ```bash
   cd /home/z/my-project
   unzip -o <zip路径> -d .
   ```
   解压后得到 `localsend-review-handoff/` 目录；**先把包内 `worklog.md` 复制到工作区根目录**（worklog 协议要求它位于 `/home/z/my-project/worklog.md`）。
3. **重建 localsend 源码（commit 钉死，不可用其他版本）**：
   ```bash
   git clone https://github.com/localsend/localsend /home/z/my-project/localsend
   cd /home/z/my-project/localsend
   git checkout 9529e915f438d8edd8bdf23e9f7aab2261a8b3e6
   # 若该 commit 已不在 main 顶端导致 checkout 失败：
   git fetch origin 9529e915f438d8edd8bdf23e9f7aab2261a8b3e6 && git checkout FETCH_HEAD
   ```
4. **应用 P0 补丁（二选一，推荐 a）**：
   - a) `git -C /home/z/my-project/localsend apply /home/z/my-project/localsend-review-handoff/deliverables/localsend-p0-fixes.patch`
   - b) 或用 `deliverables/modified-source/` 下 5 个文件按相同相对路径覆盖仓库文件。
5. **验证恢复**：`git -C /home/z/my-project/localsend status --short` 应显示恰好 5 个 M 文件（main.dart、local_ip_provider.dart、settings_provider.dart、scan_facade.dart、network_info_provider_test.dart）；对照第 2.1 节 MD5 表抽查 2~3 个文件。
6. **（仅当需要交付站点时）重建 Next.js 站点**：用 fullstack-dev 技能初始化 Next.js 16 脚手架后，把 `site-src/` 内文件按其中 README 的映射放回对应路径，`bun add remark-gfm`，`bun dev`（端口 3000）。

**为什么不含 localsend 仓库本体与 superpowers 技能库**：重克隆成本远低于打包体积（仓库含 .git 数十 MB），且版本已钉死；superpowers 技能库重克隆 `https://github.com/obra/superpowers` 即可（仅 subagent 评审工作流需要，非必需）。

---

## 2. 包内资产清单（含 MD5 校验和）

解压后的包结构（`localsend-review-handoff/` 下）：

```
localsend-review-handoff/
├── HANDOFF.md            ← 本文件（下一 agent 先读这个）
├── worklog.md            ← 9 个 Task ID 的完整决策档案（恢复到工作区根目录）
├── deliverables/         ← 用户交付物
│   ├── LocalSend传输优化总报告-评审报告.md   （核心智力产出）
│   ├── localsend-p0-fixes.patch             （git apply 可直接应用）
│   ├── modified-source/app/...              （5 个修改后文件完整副本）
│   ├── preview-review-tab.png               （浏览器验证截图）
│   └── preview-delivery-tab.png
├── original-report/      ← 被评审的原报告（用户上传原件，神圣不可修改）
│   └── LocalSend传输优化总报告.md
├── review-parts/         ← 评审报告 v1/v2 草稿分片（决策过程留痕）
│   ├── part1.md / part2.md / part3.md       （v1）
│   └── v2_part1.md / v2_part2.md / v2_part3.md
└── site-src/             ← Next.js 交付站点源文件（5 文件 + 恢复 README）
```

### 2.1 关键文件校验和

| 文件（包内路径） | MD5 |
|---|---|
| `deliverables/LocalSend传输优化总报告-评审报告.md` | `f470dca49acd744e55693584cfb4e800` |
| `deliverables/localsend-p0-fixes.patch` | `19698cb83e356894a20f462322741684` |
| `deliverables/modified-source/app/lib/main.dart` | `95fe9aca246b83ab44a04c49c94677dc` |
| `deliverables/modified-source/app/lib/provider/local_ip_provider.dart` | `8887b404081aa90b17271dac79401475` |
| `deliverables/modified-source/app/lib/provider/settings_provider.dart` | `e1d1cf5007b892a844d0f814bd34c406` |
| `deliverables/modified-source/app/lib/provider/network/scan_facade.dart` | `aa0ed189120cb29da9bd4db86df374c7` |
| `deliverables/modified-source/app/test/unit/provider/network_info_provider_test.dart` | `eb78b2b5fbab2949c3f0eeb34f5ee68b` |
| `original-report/LocalSend传输优化总报告.md` | `710600c4750d06e1cbe0c7ffc90e0203` |
| `worklog.md` | `b9b42830a4661e7c2ee58945c5e8a1ee` |
| `deliverables/preview-review-tab.png` | `568e3c51031d863932b9f3392cba15cb` |
| `deliverables/preview-delivery-tab.png` | `3ad4f1c7a160cce0f4f8148e1bda32b5` |
| `review-parts/part1.md` | `dd964c486abaedf4887c09f25d4350b5` |
| `review-parts/part2.md` | `5c0a7f89f469ca8a748dda0832da49b4` |
| `review-parts/part3.md` | `d85f585088d54a3575fd5a634e8c8147` |
| `review-parts/v2_part1.md` | `449870ec32150a081bb4907651e9467c` |
| `review-parts/v2_part2.md` | `73875340ccd506d0e682ec1598f8cf24` |
| `review-parts/v2_part3.md` | `d15de6654ac5a3d3d6dfb6ac95ce0719` |
| `site-src/app/page.tsx` | `f62d5d821ae1f1a2cf806a6d2e3173a8` |
| `site-src/app/layout.tsx` | `9cbedbdf4ff20860c54295dfb36a8ff0` |
| `site-src/lib/content.ts` | `5b846125dc8aecd59d7bbaae7fd2ae85` |
| `site-src/components/delivery/markdown-view.tsx` | `be286c2c7f40c94af76bb2bcf9d0d080` |
| `site-src/components/delivery/patch-viewer.tsx` | `fa9c688fa2f68810b07ae15b92fe8c33` |

---

## 3. 核心结论速查（环境无关，已双重验证，可直接引用）

### 3.1 对原报告的评判（详见评审报告 v2 第一节评分表）

- **成立**：四个失效机制（socket 不重绑 / 单接口静默死亡 / TTL=1 / `.1` 排序漏热点网段）全部在源码找到确凿支撑；E.2 陷阱清单 12 处实质全部成立；4 个 GitHub issue 与维护者引言逐字属实（在线核验 #144/#427/#850/#2924）。
- **错误**：7 处行号错标（scan_facade.dart:22→实际15/21、api/discovery.rs:141→实际144、favorite_device.dart:16→12、device.dart:56→58、discovery.dart:30→28、event_backpressure:29→27、init:191→190）；机制 2 日志量级写反（实际 10 warn + 1 error，非"只有一条 warn"）；机制 4"全盘失联"过强（漏 UI 子网选择兜底 send_tab.dart:331 + 349-354）；降级 2 不知发现超时已是用户可配置项（settings_tab.dart:466-478）。
- **遗漏**：完全没查 CONTRIBUTING.md:5-9 与 AGENTS.md:3-7 的 AI 贡献限制条款（2026-07-25 commit 4199cfd8 加入）；两份报告共同最大盲区 = Android MulticastLock/CHANGE_WIFI_MULTICAST_STATE 全仓缺失；README 已列的三类失效（防火墙/VPN/iOS 权限）被跳过。

### 3.2 评审的新发现（经魔鬼代言人 6 条反例路径攻击后全部幸存，事实核查员独立证实）

1. **现存 bug**：whitelist/blacklist/discoveryTimeout 变更后运行中的 discovery 不重启、配置不生效（`settings_provider.dart:21-40` + `discovery.dart:59-79`；doc 注释三证据：discovery.dart:124 / discovery_isolate.dart:40 / actions.dart:169 均写明 restart 意图含 network settings changed）。
2. 事件通道满时静默丢弃已确认设备（`discovery/mod.rs:193-207`，容量 16，`try_send` 满即丢）。
3. HTTP 模式无认证注册可注入假设备（`server/v2.rs:163-166`，`None => true`）。
4. 安全拓展：通道劫持攻击面（store.rs:206-227）、AirDrop 类比应为 PrivateDrop USENIX Sec'21。

### 3.3 上游贡献关键情报（Task 3-e，决定 PR 策略）

- AI 政策三条豁免为 OR 关系；"人类执笔 + AI 辅助 + 如实披露"比援引豁免更稳。
- git blame：`main.dart` iOS-only 重绑门是维护者 Tienisto 63efbe6b（2026-08-18）刻意设计（注释明言 "multicast sockets ... cannot be probed, so always rebind them"）；`.1` 排序是 338f9a725（2023-01-06）刻意行为、4 个测试钉死。改它们需 issue 先行而非直接 PR。
- 89303dcf（2026-08-17）已有 multicastError() 上报 + 全部 socket 死亡后 1 秒退避自愈循环——新机制应扩展该设施而非另起炉灶。
- 评审 3-e 建议序列：Issue×2 + PR×3（设置重启 PR ≤20 行可首发；`.1` 排序走 heuristic-gap issue；仓库 8 月下旬起进入稳定维护期，是贡献好窗口）。
- "快照漂移"推测已证伪：评审 checkout 与报告基线同一 commit，错标文件 2026-08-24 后冻结 ≥5.5 周。

### 3.4 P0 代码修复（5 文件 +83/−6 行）

| Fix | 文件 | 内容 |
|---|---|---|
| 1 | settings_provider.dart | 设置同步后追加 `IsolateDiscoveryRestartAction`（带 discovery!=null 守卫）；利用同通道 FIFO 保证子 isolate 先收到新 syncState 再重启 |
| 2 | local_ip_provider.dart | (a) 移除 `.1` 降权特例（热点网关优先）；(b) Windows 10 秒接口轮询；(c) IP 集合实际变化才派发重绑 |
| 3 | scan_facade.dart | maxInterfaces 3→5 |
| 4 | main.dart | resumed 重绑扩展到 Android（注释标明与 63efbe6b 设计张力） |
| 5 | network_info_provider_test.dart | +3 测试：Android/iOS 热点网关优先、native `.1` 仍排最后 |

---

## 4. 环境约束与陷阱（下一 agent 必读）

1. **无工具链**：环境没有 `cargo`/`rustc`/`flutter`/`fvm`——所有 Rust/Flutter 断言只能静态分析，不能编译验证。**补丁从未被 `fvm flutter test` 真实运行过**（大括号/圆括号平衡已人工检查）。
2. **GitHub API 限流**：api.github.com 返回 403，核验 issue 要改抓 HTML 页面。
3. **行号基准**：一切 `文件:行号` 以 localsend `9529e915` 为准；评审报告 v2 的行号已被事实核查员抽验 40+ 处零实质错误，可直接信任。
4. **worklog 协议**：接手任何任务前先读 `worklog.md`（恢复到 `/home/z/my-project/worklog.md` 后）；完成后按模板追加段落（`---` 开头 + Task ID/Agent/Task/Work Log/Stage Summary），禁止覆盖。
5. **原报告神圣不可动**：`original-report/LocalSend传输优化总报告.md` 是用户原件，评审与修订都要以副本/独立文档形式进行。
6. **站点内容是磁盘读**：`site-src/lib/content.ts` 服务端直接读磁盘路径——**恢复站点时需把 content.ts 里的路径改成实际解压/交付路径**；替换交付物后站点自动更新，无需改前端组件。
7. **不要重复已完成的核查**：79 处引用两轮核查已覆盖；只有用户提出的新断言才需要验证。
8. **subagent 无上下文**：派发 subagent 时 prompt 必须自包含（基准 commit、文件路径、判定标准），并要求它们先读 worklog 再工作、完成后追加记录。

---

## 5. 待办事项（按优先级）

1. **[需 Flutter 环境] 验证 P0 补丁**：`fvm flutter analyze && fvm flutter test app/test/unit/provider/network_info_provider_test.dart`（在 localsend 仓库根目录；新增 3 用例 + 原有 4 用例应全绿）。
2. **[需 GitHub] 上游贡献**：按评审报告"拓展三"与 Task 3-e 修正后的序列执行——先发 2 个 issue（heuristic-gap：`.1` 排序；MulticastLock 盲区），再发首发 PR（设置变更触发重启，≤20 行）；注意 AI 贡献政策合规（人类执笔 + 披露）。
3. **[可选] 修订原报告**：若用户要求修订（而非只评审），另立文档，用 v2 第三节修正行号表逐条替换，不改动原件。
4. **[可选] P1/P2 拓展**（评审报告拓展一/二已给方向、未写代码）：事件通道背压改造、Android MulticastLock 调研、`server/v2.rs` HTTP 认证。

---
---

# 给下一个 Agent 的完整提示词（自包含、已适配全新重置环境，可直接复制使用）

```markdown
# 任务交接：LocalSend 传输链路优化报告评审项目（重置环境版）

## 你是谁、你要接手什么
你是接手一个已完成 90% 工作的项目的 agent。项目目标曾为：克隆 localsend 源码，
审阅用户上传的《LocalSend 传输链路优化总报告》（行号级源码分析报告），进行评判、
挑刺、拓展。主链路已全部完成：源码核查 → 5 视角 subagent 评审团 → 评审报告 v2
定稿 → P0 代码修复 → Next.js 交付站点。你接手的是验证、上游贡献、或用户后续
迭代需求。本会话是全新重置环境，交接包 zip 是唯一存活资产。

## 第一步（强制，按顺序）
1. 定位交接包：download/ 下的 localsend-review-handoff-20261003.zip；若无，
   请用户重新上传（会出现在 upload/）。
2. 解压恢复：cd /home/z/my-project && unzip -o <zip> -d . ，并把包内
   worklog.md 复制到 /home/z/my-project/worklog.md。
3. 读包内 HANDOFF.md（资产清单含 MD5 + 核心结论速查 + 环境陷阱）→ 读
   worklog.md（9 个 Task ID 决策档案）→ 读 deliverables/ 内评审报告 v2
   （235 行定稿，核心智力产出）。
4. 重建 localsend 源码并钉死版本：
   git clone https://github.com/localsend/localsend /home/z/my-project/localsend
   cd /home/z/my-project/localsend
   git checkout 9529e915f438d8edd8bdf23e9f7aab2261a8b3e6
   （shallow 失败则：git fetch origin 9529e915f438d8edd8bdf23e9f7aab2261a8b3e6
   && git checkout FETCH_HEAD）
5. 应用 P0 补丁：git -C /home/z/my-project/localsend apply
   /home/z/my-project/localsend-review-handoff/deliverables/localsend-p0-fixes.patch
   （或用 deliverables/modified-source/ 5 文件覆盖同相对路径）。
6. 验证：git status --short 恰 5 个 M 文件；md5sum 对照 HANDOFF 第 2.1 节。

## 项目基准（不要重新考证，已双重验证）
- 源码：localsend main @ 9529e915f438d8edd8bdf23e9f7aab2261a8b3e6（app
  1.18.2+64），与被评审报告声称的基线为同一 commit，无版本漂移。
- 评审结论：原报告 4 个失效机制全部成立、E.2 陷阱 12 处实质成立、GitHub 引文
  逐字属实；但有 7 处行号错标、2 处定性偏差、1 处论据链断裂（机制 2 日志量级
  写反）；遗漏 Android MulticastLock 盲区与 CONTRIBUTING/AGENTS.md 的 AI
  贡献限制条款。
- 评审新发现 4 条（均经魔鬼代言人 6 条反例路径攻击幸存）：①设置变更后
  discovery 不重启（现存 bug，settings_provider.dart:21-40 + discovery.dart:
  59-79）；②事件通道容量 16 try_send 满即丢（discovery/mod.rs:193-207）；
  ③HTTP 模式无认证注册（server/v2.rs:163-166）；④README 三类失效被跳过。
- P0 修复已做：5 文件 +83/−6 行（详见 HANDOFF 3.4 节），补丁在
  deliverables/localsend-p0-fixes.patch，从未真实编译/跑过测试。

## 环境硬约束
- 本机没有 cargo/rustc/flutter/fvm：任何 Flutter/Rust 验证只能静态分析，或
  明确告知用户需在有工具链的环境执行。
- GitHub API 403 限流：核验 issue 用 HTML 页面抓取，不用 api.github.com。
- 一切行号以 9529e915 为准；评审报告 v2 的行号已抽验 40+ 处，可信任。
- original-report/ 内是用户原件，禁止修改。

## 已排队的工作（用户未给新指令时按此优先级）
1. [需 Flutter] 在有 fvm 的环境：cd /home/z/my-project/localsend &&
   fvm flutter analyze && fvm flutter test
   app/test/unit/provider/network_info_provider_test.dart
   （预期新增 3 用例 + 原有 4 用例全绿；失败则对照 deliverables/
   modified-source/ 排查，禁止凭记忆重写）。
2. [需 GitHub] 上游贡献按 Task 3-e 修正后序列：先 2 个 issue（`.1` 排序
   heuristic-gap、Android MulticastLock 盲区），再首发 PR（设置变更触发
   discovery 重启，≤20 行，无疑义 bug fix）；`.1` 排序与 resumed 全平台化
   是维护者刻意设计（63efbe6b / 338f9a725），必须 issue 先行、不得直接 PR；
   新机制要扩展 89303dcf 既有 multicastError/自愈设施。AI 合规走"人类执笔 +
   AI 辅助 + PR 描述如实披露"，并自查 AGENTS.md:3-7。
3. [可选] 若用户要"修订原报告"：另立文档，用评审报告 v2 第三节的 7 处行号
   修正表逐条替换，不改动原件。
4. [可选] P1/P2 拓展（评审报告拓展一/二已给方向、未写代码）：事件通道背压、
   MulticastLock、server/v2.rs HTTP 认证。

## 交付站点（可选重建）
- 交接包 site-src/ 内是 Next.js 16 单页应用的 5 个源文件（4 tab：评审报告 v2 /
  原报告 / 代码修改 diff 查看器 / 交付与验证）+ 恢复 README。
- 仅当用户要看站点时才重建：fullstack-dev 技能初始化脚手架 → 按映射放回
  site-src 文件 → 修改 lib/content.ts 里的磁盘路径指向实际解压位置 →
  bun add remark-gfm → bun dev（3000）→ bunx eslint src/ → agent-browser
  端到端验证（先例：Task 7，验证过 4 tab 渲染 + 390px 移动端 + console 无错）。
- 站点内容是服务端磁盘读，不要把内容硬编码进前端组件。

## 行为准则
- 任何新任务开工前读 worklog.md；完成后按模板追加（--- 开头 + Task ID /
  Agent / Task / Work Log / Stage Summary），禁止覆盖已有内容。
- 事实断言必须带 文件:行号 证据；引用上游态度必须带 git blame/commit 号。
- 不要重复已完成的核查（79 处引用两轮已覆盖）；用户问到的新断言才需重验。
- subagent 只接收你传递的 prompt（无对话上下文）：派发任务时自包含基准
  commit、文件路径、判定标准，并要求先读 worklog.md、完成后追加记录。
- 最终交付物一律落 /home/z/my-project/download/，用描述性中文文件名；
  若产出新的关键工件，考虑更新交接包或单独存档并告知用户。
```

---

# 交接检查单（Signing Checklist）

- [x] 单一 zip 工件，解压即恢复 90% 工作状态（剩余 10% = 重克隆仓库，命令已给出）
- [x] 全部 22 个关键文件带 MD5 校验和
- [x] 原报告原件未被改动（MD5 存档）
- [x] worklog.md 完整覆盖 9 个 Task ID 的决策链
- [x] 环境约束（无工具链、GitHub 限流、重置后路径变化）已显式写入
- [x] 待办工作已排序且标注所需环境
- [x] 交接提示词自包含且已适配重置环境（解压恢复 + 重建仓库为第一步）
