# Flutter 升级成本评估（3.41.9 → 3.47.6）

> 评估基线：localsend@9529e915 + P0 修复（1ac3fea3）。版本事实均经联网核实
> （storage.googleapis.com/flutter_infra_release/releases/releases_linux.json），
> API 统计基于本地源码 rg 全仓检索。评估人：R-10 审查 subagent（round-1）+ 主 agent 复核。

## 1. 目标版本（联网核实）

| 项 | 值 |
|---|---|
| 当前钉死（.fvmrc + 13 个 workflow） | 3.41.9（2026-04-30，Dart 3.11.5） |
| 当前 stable | **3.47.6**（2026-10-01，Dart 3.13.5） |
| 跨越列车 | 3.44.0 + 3.47.0（两列车） |
| 最近 3 个 stable | 3.47.6 / 3.47.5 / 3.47.4 |

## 2. 阻塞项清单（无真正 blocker，均为低危/决策项）

1. **macOS 最低支持 10.15 → 12**（Flutter PR #188520）：flutter_tools 会把
   macos 11.0 部署目标自动改写为 12.0 → 放弃 macOS 11 用户，属产品决策；
   升级 PR 需显式包含此 diff。
2. **device_apps fork 声明 `sdk <3.0.0`**（override 放行的既有怪癖；lock 证明
   Dart 3.11.5 可解析；3.13 行为 UNVERIFIED）。
3. **formatter/analyzer 漂移**：CI 有 `dart format --set-exit-if-changed` 门禁，
   新 SDK 可能要求一次性 reformat（本仓库 page_width=150）。
4. **版本钉同步**：.fvmrc + **13 个 workflow** 的 `FLUTTER_VERSION: "3.41.9"`
   必须同一 PR 更新。

## 3. 代码迁移面（本地静态统计，全部为 0）

- 弃用 API 命中：WillPopScope / MaterialState 系 / withOpacity / Color.value /
  TextTheme 旧字段（headline4 等）/ toggleable·SelectableRegion·onSystemNavigator —— **全 0**
- 升级窗口内 10 项官方 breaking changes（3.44×8 + 3.47×2，docs.flutter.dev
  逐页核实 "In stable release"）：受影响 API 在仓内命中 **全 0**
- Kotlin BC：仅强制 AGP 9+（本项目 AGP 8.12.1 不在范围）
- 35+ 包 pub.dev API 核实：钉版依赖全部 `>=` 下限、零 flutter 上限；
  实际关键栈为 refena_flutter 3.5.0 / routerino / window_manager 0.5.2
  （并非 riverpod/go_router）
- flutter_rust_bridge 双侧一致（Rust `=2.12.0` / Dart lock 2.12.0，
  sdk `>=3.4.0 <4.0.0`）→ 升级**不需要**重新 codegen；rustc 1.97.1 独立

## 4. P0 补丁自身的兼容性

补丁 11 个文件只用：AppLifecycleState/WidgetsBindingObserver、dart:async Timer、
refena 3.5.0（external/dispatch/setEquals 语义与 SDK 版本无关）、钉版插件、
package:test → **升级时无需任何调整**（已核对）。

## 5. 成本判定

| 阶段 | 工作量 | 说明 |
|---|---|---|
| 代码迁移 | **低（<1 天）** | 0 弃用命中、0 BC 碰撞、0 依赖上限冲突、补丁零修改 |
| 全平台构建验证 | **中（1-3 天）** | Android → Windows → Linux → macOS/iOS 顺序回归 |

回退策略：revert 单一版本钉 commit 即可（依赖全精确钉版，无残留）。

## 6. 建议升级路径（两阶段）

1. **先升 SDK**：.fvmrc + 13 workflows 同 PR → `flutter pub get` →
   `flutter analyze`（app + isolates + cargokit）→ `flutter test`（97+18 用例）→
   `dart format` 一次性收口 → 分平台 build。
2. **后续独立排期**：AGP9/Kotlin、material_ui 包迁移、依赖升级（109 个
   outdated 但与 SDK 升级解耦）。

## 7. 结论

3.41.9 → 3.47.6 为**低风险低成本**升级；无代码级阻塞；真正的成本在
多平台构建验证与版本钉同步的流程纪律。建议在 P0 修复被上游接纳或
fork 稳定运行后作为独立变更执行。
