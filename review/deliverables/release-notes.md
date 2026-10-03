# LocalSend 传输优化独立评审 + P0 修复（v1）

评审基线：localsend/localsend `main` @ `9529e915`（2026-10-03，app `1.18.2+64`），与被评审报告声称的基线为同一 commit，无版本漂移。

本 fork `main` = 上游基线 + P0 修复（`9a661080`，经 PR #1 合并）+ 评审存档（`review/` 目录）。

## 产物清单

| 文件 | 说明 |
|---|---|
| `localsend-p0-fixes.patch` | P0 修复补丁，`git apply` 可直接应用（5 文件 +83/−6） |
| `review-report-v2.md` | 独立评审报告 v2.0 定稿（235 行，核心智力产出） |
| `original-report.md` | 被评审的原报告（用户原件，未做任何改动） |
| `modified-source.zip` | 5 个修改后源文件完整副本（含相对路径） |
| `review-archive.zip` | 完整评审存档（报告/草稿分片/补丁/站点源码/工作日志/交接档案/验证截图） |

## P0 修复内容（5 文件 +83/−6）

| Fix | 文件 | 内容 |
|---|---|---|
| 1 | `app/lib/provider/settings_provider.dart` | 设置同步后追加 `IsolateDiscoveryRestartAction`（带 discovery!=null 守卫），修复 whitelist/blacklist/discoveryTimeout 变更后运行中的 discovery 不重启的现存缺陷 |
| 2 | `app/lib/provider/local_ip_provider.dart` | 移除 `.1` 降权特例（热点网关优先）；Windows 10 秒接口轮询；IP 集合实际变化才派发重绑 |
| 3 | `app/lib/provider/network/scan_facade.dart` | maxInterfaces 3→5（多网卡 + 热点场景） |
| 4 | `app/lib/main.dart` | resumed 重绑扩展到 Android（注释标明与上游 63efbe6b 设计张力） |
| 5 | `app/test/unit/provider/network_info_provider_test.dart` | +3 测试用例（Android/iOS 热点网关优先、native `.1` 仍排最后） |

## 验证状态

- ✅ 补丁对基线干净应用（`git apply --check` 通过）；MD5 全链路校验（交付记录 ↔ main 合并树逐字节一致）；测试文件 7 用例（旧 4 + 新 3）；Dart 括号平衡静态检查通过
- ⚠️ **未经 Flutter 工具链验证**：编写环境无 `cargo`/`rustc`/`flutter`/`fvm`。请在有工具链的环境执行：
  ```bash
  fvm flutter analyze && fvm flutter test app/test/unit/provider/network_info_provider_test.dart
  # 预期：新增 3 用例 + 原有 4 用例全绿
  ```
- ⛔ 未向上游提交任何 issue/PR（owner 决策：验证完成前不提交）

## 出处声明

AI 辅助独立评审。完整决策档案（源码核查 → 5 视角评审团反审查 → P0 修复 → 交付）见仓库 `review/worklog.md`；上游贡献政策合规路径见评审报告拓展三。
