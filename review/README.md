# LocalSend 传输链路优化报告 · 独立评审存档

> 评审基线：localsend/localsend `main` @ [`9529e915`](https://github.com/localsend/localsend/commit/9529e915f438d8edd8bdf23e9f7aab2261a8b3e6)（2026-10-03，app `1.18.2+64`）
> 本目录：独立评审全程智力产出与交付物的持久化存档，位于本 fork 的 `main` 分支
> 发布产物：GitHub Release [`p0-review-v1`](https://github.com/purrfecto114-lgtm/localsend/releases/tag/p0-review-v1)（补丁 / 报告 / 源码 zip）

## main 分支的构成

| commit | 内容 |
|---|---|
| `9529e915` | 上游基线（与被评审报告声称的基线同一 commit，无版本漂移） |
| `9a661080` | P0 修复（5 文件 +83/−6，经 fork PR #1 合并） |
| `571c352f` | PR #1 合并提交 |
| 之后提交 | 本存档（review/）+ release workflow |

## 项目是什么

对《LocalSend 传输链路优化总报告》（行号级源码分析报告）完成的完整评审闭环：

**克隆源码（commit 钉死）→ 逐条核查 79 处引用 → 5 视角 subagent 评审团反审查（43 条意见）→ 评审报告 v2 定稿 → P0 代码修复（5 文件 +83/−6 行）**

## 核心结论速查

- **原报告的评判**：四个失效机制（socket 不重绑 / 单接口静默死亡 / TTL=1 / `.1` 排序漏热点网段）全部在源码找到确凿支撑；E.2 陷阱清单 12 处实质全部成立；4 个 GitHub issue 与维护者引言逐字属实。但存在 7 处行号错标、2 处定性偏差、1 处论据链断裂，且遗漏 Android MulticastLock 盲区与 CONTRIBUTING/AGENTS.md 的 AI 贡献限制条款。
- **评审新发现**（经魔鬼代言人 6 条反例路径攻击后全部幸存）：
  1. 现存 bug：whitelist/blacklist/discoveryTimeout 变更后运行中的 discovery 不重启（`settings_provider.dart:21-40` + `discovery.dart:59-79`）
  2. 事件通道满时静默丢弃已确认设备（`discovery/mod.rs:193-207`，容量 16，`try_send` 满即丢）
  3. HTTP 模式无认证注册可注入假设备（`server/v2.rs:163-166`，`None => true`）
  4. 通道劫持攻击面（`store.rs:206-227`）
- **P0 修复**（5 文件 +83/−6 行）：

| Fix | 文件 | 内容 |
|---|---|---|
| 1 | `app/lib/provider/settings_provider.dart` | 设置同步后追加 `IsolateDiscoveryRestartAction`（带 discovery!=null 守卫） |
| 2 | `app/lib/provider/local_ip_provider.dart` | 移除 `.1` 降权特例（热点网关优先）；Windows 10 秒接口轮询；IP 集合实际变化才派发重绑 |
| 3 | `app/lib/provider/network/scan_facade.dart` | maxInterfaces 3→5 |
| 4 | `app/lib/main.dart` | resumed 重绑扩展到 Android（注释标明与上游 63efbe6b 设计张力） |
| 5 | `app/test/unit/provider/network_info_provider_test.dart` | +3 测试：Android/iOS 热点网关优先、native `.1` 仍排最后 |

## 本目录结构

```
review/
├── README.md                        ← 本文件
├── HANDOFF.md                       ← 交接文档（资产清单 + MD5 + 环境陷阱 + 待办）
├── worklog.md                       ← 全部 Task ID 的完整决策档案
├── original-report/                 ← 被评审的原报告（用户原件，神圣不可修改）
│   └── LocalSend传输优化总报告.md
├── review-report/                   ← 核心智力产出
│   └── LocalSend传输优化总报告-评审报告.md   （v2.0 定稿，235 行）
├── review-parts/                    ← 评审报告 v1/v2 草稿分片（决策过程留痕）
│   ├── part1.md / part2.md / part3.md           （v1）
│   └── v2_part1.md / v2_part2.md / v2_part3.md
├── deliverables/                    ← P0 修复交付物
│   ├── localsend-p0-fixes.patch     （git apply 可直接应用）
│   ├── modified-source/             （5 个修改后文件完整副本）
│   ├── release-notes.md             （Release 说明，workflow 引用）
│   └── preview-*.png                （交付站点浏览器验证截图）
└── site-src/                        ← Next.js「源码储存站」站点源文件
```

## 完整性校验（MD5）

| 文件 | MD5 |
|---|---|
| `review-report/LocalSend传输优化总报告-评审报告.md` | `f470dca49acd744e55693584cfb4e800` |
| `deliverables/localsend-p0-fixes.patch` | `19698cb83e356894a20f462322741684` |
| `original-report/LocalSend传输优化总报告.md` | `710600c4750d06e1cbe0c7ffc90e0203` |
| `deliverables/modified-source/app/lib/main.dart` | `95fe9aca246b83ab44a04c49c94677dc` |
| `deliverables/modified-source/app/lib/provider/local_ip_provider.dart` | `8887b404081aa90b17271dac79401475` |
| `deliverables/modified-source/app/lib/provider/settings_provider.dart` | `e1d1cf5007b892a844d0f814bd34c406` |
| `deliverables/modified-source/app/lib/provider/network/scan_facade.dart` | `aa0ed189120cb29da9bd4db86df374c7` |
| `deliverables/modified-source/app/test/unit/provider/network_info_provider_test.dart` | `eb78b2b5fbab2949c3f0eeb34f5ee68b` |

工作树中的对应源文件（`app/lib/...`）与上表逐字节一致（main 分支合并树已核验）。

## 上游贡献策略（评审 Task 3-e 结论，暂缓执行）

- 仓库 AI 政策三条豁免为 OR 关系；"人类执笔 + AI 辅助 + 如实披露"比援引豁免更稳。
- `main.dart` iOS-only 重绑门是维护者 Tienisto `63efbe6b`（2026-08-18）刻意设计；`.1` 排序是 `338f9a725`（2023-01-06）刻意行为、4 个测试钉死。改它们需 **issue 先行**而非直接 PR。
- 建议序列（**用户已明确指示：验证完成前不向上游提交**）：Issue×2（`.1` 排序 heuristic-gap、Android MulticastLock 盲区）+ PR×3（设置重启 PR ≤20 行可首发）。
- 新机制应扩展 `89303dcf` 既有的 multicastError 上报 + 自愈循环，而非另起炉灶。

## 验证状态

- ✅ 补丁对 `9529e915` 干净应用（`git apply --check` 通过）；main 合并树 5 文件 MD5 与交付记录逐字节一致；测试文件 7 用例（旧 4 + 新 3）；Dart 括号平衡静态检查通过
- ⚠️ **未经工具链验证**：编写环境无 `cargo`/`rustc`/`flutter`/`fvm`。验证命令：
  ```bash
  fvm flutter analyze && fvm flutter test app/test/unit/provider/network_info_provider_test.dart
  # 预期：新增 3 用例 + 原有 4 用例全绿
  ```
- ⛔ 未向上游提交任何 issue/PR（owner 决策：先验证）

## 出处声明

AI 辅助独立评审（完整决策档案见 `worklog.md`）。上游贡献政策的合规路径见评审报告拓展三。
