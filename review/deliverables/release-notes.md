# LocalSend 传输优化独立评审 + P0 修复（v2 · 经 15 个审查 agent 双轮验证 + 真实工具链验证）

评审基线：localsend/localsend `main` @ `9529e915`（2026-10-03，app `1.18.2+64`）。
本 fork `main` = 上游基线 + P0 修复（v1: `9a661080` → v2 加固: `7d25f792` + `1ac3fea3`）+ 评审存档（`review/`）。

## v2 相比 v1 的变化（为什么重新发版）

v1 的补丁**未经过任何工具链验证**（编写环境无 Flutter）。v2 阶段下载了钉死的
Flutter 3.41.9 SDK，派遣 10 个审查 subagent 做多角度全方位审查（调用链/竞态/
用户环境矩阵/上游一致性/测试质量/CI 链路），随后自行修复、再由 5 个验证
subagent 复验。**工具链实证发现了 v1 的 2 个编译错误和 1 个逻辑反转**：

| 级别 | v1 缺陷 | v2 修复 |
|---|---|---|
| Critical | `global.read/global.dispatch` 在 refena 3.5.0 不存在 → **不可编译**（flutter analyze 实证 2 errors） | 改用库文档的 `external(controller).dispatch` 模式 |
| Critical | `toSet() != toSet()` 是同一性比较恒真 → "仅集合变化才重绑"被反转为**每次 fetch 都重绑**（Windows 上 10 秒一轮全网 announce/register 风暴） | `setEquals` + 提取为纯函数 `shouldRebindDiscovery` + 8 个回归测试 |
| Critical（v2 审查新发现，**上游也有**） | refena 3.5.0 的 provider 级 `onChanged` 仅在容器有 observer 时触发，而 `init.dart` 只在 debug 传 observer → **settings 同步链在 release/profile 是死代码**（上游 server/security/deviceInfo 同样受影响） | release 也传入 no-op observer（`OnChangeEnablingObserver`） |
| Important | 空列表 → 非空永不重绑（离线启动无自愈）；首抓取挂起/抛异常会传染"首轮"语义 | `initialized \|\| fetchId > 1` 判定 + 测试钉死 |
| Important | Windows 10s 轮询每 tick 调 `getWifiIP()` → 位置敏感 WLAN 查询（上游 221f40a9 正是为此删除过 Windows 轮询，已联网核实 diff） | 轮询路径跳过 getWifiIP（`includeWifiIp: false`） |
| Important | 重绑窗口内到达的 restart 被静默吞掉（终值丢失，UI 与运行配置不一致） | `_restartPending`：绑定后补停再重绑，跳过无谓 announce |
| Important | settings 超时输入框逐键触发 sync+restart 风暴 | sync 立即 + restart 500ms 去抖 |
| Important | Android 对每次文件选择器/对话框交互都发 resumed → 重绑风暴 | Android 750ms 尾随去抖；iOS 保持上游 63efbe6b 立即行为 |

## 验证状态（真实工具链，非静态断言）

- ✅ `flutter analyze`（app）：**No issues found**（修复前 2 errors）→ 日志见 `flutter-analyze.log`
- ✅ `flutter test`（app）：**97/97**（v1 为 7 用例未执行；v2 新增 12 个回归测试）→ 日志见 `flutter-test.log`
- ✅ `flutter test`（localsend_isolates）：18 passed + 4 rust-skipped（本机无 cargo，与 CI rust job 解耦）
- ✅ `dart format --set-exit-if-changed`：0 changed（page_width=150）
- ✅ 突变验证：把 `setEquals` 改回 `!=` → 4 测试红；把首轮判定改回 `isNotEmpty` → 1 测试红
- ✅ 上游一致性联网核实：上游 main 仍冻结于 9529e915（无撞车）；63efbe6b/221f40a9 两个关键上游 commit 已逐 diff 核实；issue #3509（Windows 热点互不可见）当天新开，直接佐证修复价值
- ⛔ 仍未向上游提交任何 issue/PR（owner 决策；另核实 CONTRIBUTING.md AI 贡献限制条款仍然有效）

## 产物清单（SHA256SUMS 附内）

| 文件 | 说明 |
|---|---|
| `localsend-p0-fixes.patch` | v2 全量补丁（11 文件，`git apply` 可直接应用于 9529e915） |
| `review-report-v2.md` | 独立评审报告 v2.0 定稿 |
| `original-report.md` | 被评审的原报告（用户原件） |
| `modified-source.zip` | 11 个修改后源文件完整副本（含相对路径） |
| `review-archive.zip` | 完整评审存档 + **双轮审查报告**（round1: R-2~R-10，round2: V-1~V-5）+ 验证日志 |
| `flutter-upgrade-cost.md` | Flutter 3.41.9 → 3.47.6 升级成本评估（联网核实版本事实 + 全仓 API 统计） |
| `flutter-analyze.log` / `flutter-test.log` | 真实工具链验证日志（exit 0） |

## P0 修复内容（v2 全量，11 文件）

| 文件 | 内容 |
|---|---|
| `app/lib/provider/settings_provider.dart` | 设置同步（立即）+ discovery 重启（500ms 去抖，null 守卫） |
| `app/lib/provider/local_ip_provider.dart` | `external()` 派发；`setEquals` 集合判定；空→非空自愈；fetch 版本号防旧覆新；Windows 轮询跳过 getWifiIP；`.1` 排序 + 诚实注释；`shouldRebindDiscovery` 纯函数 |
| `app/lib/provider/network/scan_facade.dart` | maxInterfaces 3→5 |
| `app/lib/main.dart` | resume 重绑：Android 750ms 去抖 + null 守卫；iOS 保持上游行为 |
| `app/lib/config/init.dart` + `refena.dart` | release 也传 observer（修复 onChanged 死代码）；debug 过滤器类名修正 |
| `packages/.../discovery.dart` | `_restartPending` 补丢失的重启窗口 |
| `packages/.../isolate.dart` | 导出任务类型（可测试性） |
| `app/pubspec.yaml` | 声明 typed_isolates 直接依赖 |
| `app/test/.../network_info_provider_test.dart` | +8 `shouldRebindDiscovery` 回归测试 |
| `app/test/.../settings_provider_test.dart` | +4 settings 链集成测试（录制式 isolate 连接器） |

## 出处声明

AI 辅助独立评审（两轮 subagent 审查团：round-1 十角度 R-1~R-10，round-2 验证 V-1~V-5，
全部报告随 `review-archive.zip` 交付）。完整决策档案见 `review/worklog.md`。
