# 陈旧依赖与上游漂移审计报告（staleness-report）

- Task ID: 36-c ｜ Agent: RESEARCH-C ｜ 审计时间: 2026-10-03 16:10~17:00 UTC（所有联网查询均为当日实时数据）
- 审计对象: `/home/z/my-project/localsend`（分支 `radical`，上游基线 `9529e915`，app 1.18.2+64）+ 交付站点 `/home/z/my-project`（Next.js）
- 性质: 只读审计，未执行任何升级/提交；本报告供后续实现波按可行度执行

## 1. 审计方法与来源

| 项目 | 方法 | 来源/证据 |
|---|---|---|
| 上游漂移 | `git fetch origin`（只读）→ `ls-remote`、`rev-list --count`、`git cherry`（patch-id 等价性甄别）、逐 commit `git show --stat` | 本地 git 仓 + GitHub 实时远端 |
| 上游最新版本 | `git tag --sort=-creatordate` + `git ls-remote origin refs/heads/main refs/tags/v1.18.2` | GitHub 实时 |
| Dart 依赖 | 读 `app/pubspec.yaml`、`packages/{localsend_isolates,typed_isolates}/pubspec.yaml`、根 `pubspec.lock`；`flutter pub outdated`（官方陈旧度工具） | 本地 + pub.dev |
| 最新版本 | curl `https://pub.dev/api/packages/<pkg>`（latest.version + published + isDiscontinued）；changelog 逐版本抓取 `pub.dev/packages/<pkg>/changelog` | pub.dev 实时 |
| Flutter SDK | `https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json`（官方 current stable） | Google 官方 |
| 弃用 API | 对 fork 改动文件（`git diff --name-only 9529e915..radical`，34 个 dart 文件）+ 全仓 grep `withOpacity(`、`WillPopScope`、旧版 TextTheme 名、`ColorScheme.background/onBackground/surfaceVariant`、`anyNotifier`；`flutter analyze` 复核 | 本地 SDK 3.41.9 |
| 站点依赖 | `/home/z/my-project/package.json` + `bun.lock` 实锁 vs `registry.npmjs.org/<pkg>/latest` | npm 实时 |
| 辅助 | web-search 技能（z-ai CLI）查 Flutter 版本动态、LocalSend 版本线索、flutter_markdown 弃用公告 | 临时脚本已删 |

## 2. 上游漂移（最重要结论：主干零漂移）

### 2.1 主干

- **`origin/main` 与我们的基线完全一致：`9529e915`，新提交数 = 0**。
  - 证据 1：`git fetch origin --verbose` 全部 `[up to date]`，无新对象；
  - 证据 2（直连远端实时）：`git ls-remote origin refs/heads/main` → `9529e915f438d8edd8bdf23e9f7aab2261a8b3e6`；
  - 证据 3：`git log --oneline --no-merges 9529e915..origin/main | wc -l` → `0`。
  - 背景原因：基线本身是上游 main 于 **2026-10-03 03:39 +0200**（即审计当天凌晨）的 HEAD，fork 是从最新鲜的 main 切出的。
- **上游没有发布比 1.18.2 更新的版本**：`git tag` 最新为 `v1.18.2`（`af0416be release: 1.18.2+64`，是基线祖先）。`patch-1.18.2` 分支（+2 提交，2026-09-12）只是发布工程分支，不含 app 代码改动。
- **与我们 5 个功能 commit（`git log 9529e915..radical`）的文件重叠冲突：无**（上游 main 零新提交，天然零冲突）。

### 2.2 侧分支要点清单（上游未合入 main 的内容，按主题）

| 主题 | 分支/commit | 内容 | 与 main 的关系（git cherry patch-id 甄别） |
|---|---|---|---|
| fix (i18n) | `weblate` `102f9894` | 修复 hi/ur 链接翻译破损与空条目（hi.json/ur.json，+5/-5） | **内容未在 main**（`+`） |
| fix (i18n) | `weblate` `fca8ead0` | Weblate 批量翻译（15 个 locale json，2026-08-04） | **内容未在 main**（`+`） |
| fix (打包) | `patch-1.18.2` `497b4488` | MSIX publisher 从 SignPath 改为 Tien 的 Trusted Signing 证书主题（2 文件 2 行） | 未在 main；**仅官方签名身份用，fork 不适用** |
| chore (CI) | `patch-1.18.2` `c4381a69` | 用 main 的当前定义替换该分支 workflows | 净效果 vs 基线 = 0（两侧 workflow 树一致），无需理会 |
| chore (CI) | 3 个 `dependabot/*` | download-artifact v7→v8、release-drafter v6→v7、Mattraks SHA 轮换 | 未合并的开口 PR；均为上游 CI 卫生项 |
| feat (参考) | `fix/android-saf-keep-file-name` `2dd6a79c` | SAF 自定义目录保存保留文件名（改 MainActivity.kt 等 4 文件） | **内容已经 squash 合入 main**（`3a79b003`，PR #3507），已包含在我们基线中（基线 blob `34034241` 与该 commit 产物一致）——SHA 不可达但内容在，**勿重复 cherry-pick** |
| feat (参考) | `feature/highlight-file` `e1aa806f`（2024-11） | "Show in folder" 高亮文件 | patch-id 显示 `-`（已在 main） |
| feat (参考) | `v1.18.2-unsigned-exe` `e9c9600f` | CI 产出未签名 exe | 已在 main（`-`；基线存在 `build_windows_exe_unsigned.yml`） |
| 陈旧 | `use-native-media-picker` `18c073cc`（2023-10） | 移除 wechat_assets_picker | 针对旧 i18n 目录结构（strings_*.i18n.json），已无法套用；仅作"减重依赖"方向参考 |
| 陈旧 | `feature/add-arm64-support` `4ac0d5c3`（2023-11） | arm64 支持 | main 已有全套 `build_linux_*_arm64.yml`，已过时 |
| WIP | `feature/webrtc`（+56 commits） | WebRTC 通道（fingerprint→token、RSA、SCREAMING_SNAKE_CASE 枚举等） | 大量 `wip` 提交，不可合并；仅说明上游未来方向（与协议红线冲突面大，fork 不跟） |
| WIP | `feature/improve-local-ip-ranking` `bc472471`（2023-02） | 按接口名打分排序（hotspot>wifi>eth） | 含 debug print 与注释掉的半成品，路径还是旧 `lib/` 结构；**思路可借鉴**（与我们 local_ip_provider 域相关）但非 cherry-pick 候选 |

### 2.3 重叠冲突分析表（文件级，唯一真重叠已甄别）

| 上游 commit 触碰文件 | 我们 fork 是否也改过 | 结论 |
|---|---|---|
| `MainActivity.kt`（2dd6a79c） | 是（MulticastLock，commit `25d091ce`） | **无冲突**：该修复内容已在基线（3a79b003 squash），我们基于其上叠加 |
| `app/assets/i18n/*.json`（weblate 两 commit） | 仅 `en.json`（maxInterfaces 文案） | **零重叠**，cherry-pick 可干净落位 |
| `support/build/msix/**`、`app/windows/*.manifest`（497b4488） | 否 | 无冲突，但不适用（见 2.2） |
| `.github/workflows/*`（c4381a69） | ci.yml/release.yml（workflow_dispatch + P0 归档发布流） | 净效果为 0，无操作必要 |

### 2.4 cherry-pick 候选表

| commit | 标题 | 为什么 | 冲突风险 | 可行度 |
|---|---|---|---|---|
| `102f9894` | fix: broken linked translations and null entry in hi/ur | 修复上游自己都承认的破损翻译（hi/ur 用户当前看到坏链接/空串）；2 文件 5 行 | 零（fork 未触碰 hi/ur） | **High** |
| `fca8ead0` | Translated using Weblate (pt-BR 等 15 locale) | 2026-08 批量社区翻译，含 zh-CN/pt-BR/ru 等大语种增量 | 零文件冲突；需 `dart run slang` 重生成 15 个 `strings_XX.g.dart`（codegen 机械） | **Medium** |
| `497b4488` | fix: update MSIX publisher to Trusted Signing | （否决项）fork 无签名证书、不在本环境产 MSIX；写入他人签名身份反而有害 | — | 不适用 |

## 3. Dart 依赖陈旧度

### 3.1 总览（`flutter pub outdated` 实测，SDK 3.41.9）

- 直依赖 63 个中 **30 个落后**（含 2 个 git override），dev 依赖 6 个中 5 个落后；其余（crypto、yaru、uuid、path_provider、shared_preferences、wechat_assets_picker 等）均为最新。
- 结构性事实：**相当一部分"落后"被 Flutter SDK 版本门控**——本地/CI 均为 3.41.9（2026-04-29 发布），官方 current stable 已是 **3.47.6**（Dart 3.13.5，2026-10-01，证据：releases_linux.json）。`pub outdated` 的 Resolvable 列显示：freezed 4.0.2、test 1.32、mockito 5.8.1、build_runner 2.16.1、intl 0.20.3、connectivity_plus 7.3.2、meta 1.19、in_app_purchase 3.3.1、system_date_time_format 1.5.1、flex_color_picker 4.0.0（changelog 明示要求 Flutter ≥3.47）、uri_content 4.0.1（要求 Flutter 3.44/Dart 3.12）、tray_manager 0.7.0 **在当前 SDK 下不可解析**，须先升 SDK。
- 注意：**上游自己也在 CI pin 3.41.9**（`.github/workflows/ci.yml` `FLUTTER_VERSION: "3.41.9"`），我们与上游对齐，SDK 升级属"可选优化"而非"追赶上游"。

### 3.2 落后 major（≥1 个大版本，共 12 个直依赖）

| 包名 | 我们的约束/实锁 | 最新 | 落后 | 升级风险（changelog 实证） |
|---|---|---|---|---|
| file_picker | 11.0.3 | 13.1.0 | 2 major | 13.0 BREAKING：`PlatformFile.length()`→`Future<int?>`、删除 12.0 弃用参数；12.0 是 federated 重写（平台包全换）。我们仅用 `getDirectoryPath`/`clearTemporaryFiles`（`app/lib/util/native/pick_directory_path.dart:22`、`cache_helper.dart:35`），API 面小 |
| device_info_plus | 12.4.0 | 13.3.0 | 1 | 13.0 BREAKING 仅因 win32 6.0：min Flutter 3.41.6/Dart 3.11.0——**我们 3.41.9 已满足**；pub outdated Resolvable=13.3.0 |
| package_info_plus | 9.0.1 | 10.2.2 | 1 | 同上 win32 6.0 门控，已满足；Resolvable=10.2.2 |
| network_info_plus | 7.0.0 | 8.2.2 | 1 | 同上；8.2.0 提及 Flutter 3.44 SPM/Kotlin（SPM 场景才相关）；Resolvable=8.2.1。**我们改过 local_ip_provider/network_info_provider_test，需重点回归** |
| permission_handler | 12.0.3 | 13.0.2 | 1 | 13.0 BREAKING：Android compileSdk 37；**新增 ACCESS_LOCAL_NETWORK 权限支持**（与 fork 本地网络主题契合）。compileSdk 涉及 android/build.gradle，本环境无 Gradle 验证 |
| dynamic_color | 1.8.1 | 2.1.0 | 1 | Resolvable=1.9.0（2.x 需更高 SDK）；2.0.2 含 AGP<9 兼容修复 |
| uri_content | 3.1.1 | 4.0.1 | 1 | 4.0 要求 Flutter 3.44/Dart 3.12 → SDK 门控；**3.1.3 可解** |
| win32_registry | 2.1.0 | 3.0.3 | 1 | 3.0.3 反而把 min Dart 降到 3.10（兼容）；仅 Windows 平台用 |
| tray_manager | 0.5.3 | 0.7.0 | 2 minor(0.x) | 0.6 重写为 nativeapi C++ 核心，导出面全变（TrayIcon/Menu 等）；Resolvable=0.5.3 → 0.7 被 SDK 门控。桌面托盘功能，无 GUI 验证手段 |
| flex_color_picker | 3.8.0 | 4.0.0 | 1 | 明示要求 Flutter ≥3.47 + Dart 3.13 → SDK 门控 |
| flutter_foreground_task | 9.2.2 | 11.0.3 | 2 | Resolvable=10.0.0（11.x 需更高 SDK）；仅 Android 前台服务用 |
| freezed (dev) | 3.2.5 | 4.0.2 | 1 | 4.0 BREAKING：不支持构造参数 `final`（Dart 3.13 语法）、需 analyzer 13 → SDK 门控；仓库仅 FRB 生成物 4 文件用 freezed（`packages/localsend_isolates/lib/rust/api/*.dart`），手写代码零使用、零 `final` 参数 |

### 3.3 落后 minor（当前 SDK 可直接升，重点区）

| 包名 | 实锁 | 最新 | 风险/备注 |
|---|---|---|---|
| refena_flutter | 3.5.0 | 3.6.0 | changelog：纯 feat（FlutterValueNotifierProvider）+ 弃用 anyNotifier（我们零使用，grep 实证）+ family null 修复。我们 fork 新增大量 refena 代码，测试套件即验证网 |
| wakelock_plus | 1.5.2 | 1.8.1 | 1.6 BREAKING 仅 min Dart 3.11（已满足）；1.7/1.8 为 Flutter 3.44/3.47 适配；Resolvable=1.7.0 |
| dart_mappable | 4.8.0 | 4.10.0 | 运行时可解；但配套 `dart_mappable_builder` 4.10 被 SDK 门控 → 升级需整体重跑 codegen，建议与 builder 同步 |
| desktop_drop | 0.7.1 | 0.8.4 | 0.8 BREAKING：Android built-in Kotlin，宿主要求 AGP 9+ → 需查 LocalSend android gradle，原生构建不可本地验证 |
| image / glob / mime / nanoid2 | 4.9.1 / 2.1.3 / 2.0.0 / 2.0.1 | 4.10.1 / 2.2.0 / 2.1.0 / 2.1.0 | 均为常规 minor，Resolvable=最新 |
| flutter_rust_bridge | 2.12.0 | 2.13.0 | Dart 侧约束 ^2.12.0 可解 2.13.0；**但 Rust 侧 `=2.12.0` 硬 pin（rust/Cargo.toml:15），跨语言生成物需 cargo 重新生成 → 本环境不可行** |
| share_handler | 0.0.22 | 0.0.25 | changelog 仅 "Upgrade Android dependencies and tools"，Dart API 无变化 |

### 3.4 落后 patch / 小版本（低风险批量区）

connectivity_plus 7.3.1→7.3.2（Resolvable 未过 = 新版需更高 SDK，暂缓）、url_launcher 6.3.2→6.3.3（可解）、slang 4.19.0→4.19.2（可解；slang_flutter/slang_build_runner 均在 4.19.0 最新）、in_app_purchase 3.3.0→3.3.1（门控）、intl 0.20.2→0.20.3（门控）、pool 1.5.2→1.5.3（^ 约束，pub upgrade 即得）、mockito 5.6.4→5.8.1（门控，约束 any）、system_date_time_format 1.4.0→1.5.1（门控）。

### 3.5 停止维护的包（pub.dev API isDiscontinued 实证）

| 包 | 状态 | 使用点 | 官方替代 |
|---|---|---|---|
| flutter_markdown 0.7.7+1 | **isDiscontinued: True, replacedBy: flutter_markdown_plus**（Flutter 3.32 起官方弃用，2025-05 终版） | 仅 `app/lib/pages/changelog_page.dart:23`（渲染 CHANGELOG.md） | flutter_markdown_plus 1.0.12（env flutter>=3.27.1，与我们兼容，API 同源） |

### 3.6 git override 状况（上游自留的临时方案，非 fork 引入）

- `device_apps` → Tienisto fork @5dc7956（pubspec 注释：等上游迁移到维护中的包）；`pasteboard` → Seidko fork（注释 "temporary workaround"），**pub.dev 已有 pasteboard 0.5.0**；`permission_handler_windows` → localsend noop fork（Windows 7 兼容，issue #1034）。三者均在基线 pubspec 中由上游维护，fork 跟随即可；移除 override 涉及桌面/macOS 行为验证（本环境不可行）→ Low。

## 4. 弃用 API 清单（有据才列）

对 fork 改动的 34 个 dart 文件（`git diff --name-only 9529e915..radical`）逐项 grep：

| 检查项 | 结果 | 证据 |
|---|---|---|
| `withOpacity(`（3.27 起弃用 → `withValues(alpha:)`） | **0 处**（fork 文件与全仓 app/、packages/ 均 0） | `rg -c "withOpacity\(" app packages --glob '*.dart'` 空 |
| `WillPopScope`（→ `PopScope`） | **0 处**（全仓） | 同上，空 |
| 旧版 TextTheme 名（subtitle1/bodyText1/headline6/caption/overline） | **0 处**（fork 文件） | rg 空；现存 titleMedium/bodySmall 均为现行 M3 名称 |
| `ColorScheme.background`/`onBackground`/`surfaceVariant` | **0 处**（fork 文件） | rg 空 |
| `anyNotifier`（refena 3.6 弃用 → `baseNotifier`） | **0 处**（全仓） | rg 空 |
| 综合复核 | `flutter analyze` → **No issues found! (ran in 10.2s)** | 2026-10-03 实跑 |

结论：**弃用 API 层面无需任何整改**；上游代码卫生良好（毕竟上游 CI 同样跑 analyze）。唯一的"弃用级"事项是依赖层面的 flutter_markdown 停止维护（见 3.5）。

## 5. 交付站点依赖陈旧度（次要，top-level 摘要）

bun.lock 实锁 vs npm latest（2026-10-03 实查 registry.npmjs.org）：

| 包 | 实锁 | 最新 | 落后 | 备注 |
|---|---|---|---|---|
| next | 16.1.3 | 16.3.8 | minor×2 | 同 major 内，`bun update` 可达 |
| react / react-dom | 19.2.3 | 19.3.0 | minor | 低风险 |
| tailwindcss | 4.1.18 | 4.3.3 | minor×2 | v4 内 |
| next-intl | 4.7.0 | 4.14.9 | minor×7 | v4 内累计差距较大 |
| @tanstack/react-query | 5.90.19 | 5.104.1 | minor | |
| zod | 4.3.5 | 4.6.5 | minor | |
| date-fns | 4.1.0 | 4.4.0 | minor | |
| react-hook-form | 7.71.1 | 7.89.0 | minor | |
| next-auth | 4.24.13 | 4.24.15 | patch | |
| zustand / sonner | 5.0.10 / 2.0.7 | 5.0.15 / 2.0.8 | patch | |
| typescript | 5.9.3 | 7.0.2 | **major** | TS7 = 原生编译器重写，非必要不动 |
| prisma / @prisma/client | 6.19.2 | 7.10.0（8.0.0-rc 在途） | **major** | 站点仅静态交付用 db 极少，收益低 |
| framer-motion | 12.26.2 | 14.0.0 | **major×2** | 动效面小 |
| recharts | 2.15.4 | 3.10.1 | **major** | |
| lucide-react | 0.525.0 | 1.51.0 | **major** | 图标 API 稳定，但仍属 major |
| @mdxeditor/editor | 3.52.3 | 4.3.2 | **major** | 站点未直接重度使用 |
| eslint | 9.39.2 | 10.12.0 | **major** | |
| z-ai-web-dev-sdk / react-markdown / vaul | 0.0.18 / 10.1.0 / 1.1.2 | 同 | 最新 | 无需动 |

## 6. 总排序：升级/更新建议表（可行度 × 收益）

评级规则：High = patch/minor 无 breaking，analyze/test 四门禁可全量验证；Medium = 需 codegen 重生成/跨 major 但 Resolvable 通过/验证有盲区；Low = SDK 门控、major+原生构建、Rust 侧（本环境无 cargo/cmake）。

| # | 建议 | 涉及 | 级别 | 验证路径 |
|---|---|---|---|---|
| 1 | **cherry-pick `102f9894`**（hi/ur 翻译修复，2 文件 5 行） | app/assets/i18n/{hi,ur}.json | **High** | slang 重生成 + 门禁四件套 |
| 2 | **非门控 minor/patch 批量刷新**：url_launcher 6.3.3、slang 4.19.2、pool 1.5.3、share_handler 0.0.25、glob 2.2.0、image 4.10.1、mime 2.1.0、nanoid2 2.1.0、uri_content 3.1.3 | pubspec+lock | **High** | 门禁四件套（全部 Resolvable 实证） |
| 3 | **refena_flutter 3.5.0→3.6.0**（纯 feat+fix，我们诊断 provider 大量受益于 family null 修复） | app+isolates pubspec | **High** | 全量 test（125+29 用例即回归网） |
| 4 | **wakelock_plus 1.5.2→1.7.0**（Resolvable 实证；1.6 breaking 仅 Dart 3.11 已满足） | pubspec | **High** | 门禁四件套 |
| 5 | **flutter_markdown → flutter_markdown_plus 1.0.12**（官方替代、单页使用、env 兼容） | changelog_page.dart + pubspec | **Medium** | analyze/test + changelog 页渲染需真机/桌面肉眼复核（本环境无 GUI，如实标注） |
| 6 | **cherry-pick `fca8ead0`**（15 locale 批量翻译，零文件冲突） | i18n/*.json + 15 个生成物 | **Medium** | slang 重生成 + 门禁 + 抽查 zh-CN/pt-BR |
| 7 | **win32 系 major：device_info_plus 13.3.0、package_info_plus 10.2.2**（breaking=win32 6.0 门控已满足） | pubspec | **Medium** | 门禁四件套；留意 win32 5.15→6.4 传递大跳 |
| 8 | **network_info_plus 7.0.0→8.2.x**（同上门控已满足；与我们改动的 local_ip_provider 同域） | pubspec | **Medium** | 重点回归 network_info_provider_test + 门禁 |
| 9 | **dart_mappable 4.10.0 + builder 同步**（Resolvable 通过，mapper 全量重生成） | settings_state.mapper 等 | **Medium** | build_runner 重生成后逐文件 diff（EXPERIENCE 坑 6：无关差异 checkout 回退）+ 门禁 |
| 10 | **permission_handler 12.0.3→13.0.2**（compileSdk 37 + ACCESS_LOCAL_NETWORK 与 fork 主题契合） | pubspec + android gradle | **Medium** | 门禁可跑，但 compileSdk/真机权限需构建侧验证（本环境局限，如实标注） |
| 11 | **file_picker 11.0.3→13.1.0**（我们 API 面仅 getDirectoryPath/clearTemporaryFiles） | pubspec | **Medium** | 门禁 + Android SAF 路径需真机抽查 |
| 12 | **flutter_foreground_task →10.0.0**（Resolvable 中间版；仅 Android 前台服务） | pubspec | **Medium** | 门禁 + 真机局限标注 |
| 13 | **desktop_drop 0.7.1→0.8.4**（AGP 9+ 要求，先核 android gradle 版本） | pubspec | **Medium/Low** | 门禁；AGP 升级不可本地验证 |
| 14 | **Flutter SDK 3.41.9→3.47.6 + 解锁链**（freezed 4 / test 1.32 / mockito 5.8 / build_runner 2.16 / intl 0.20.3 / connectivity_plus 7.3.2 / flex_color_picker 4 / uri_content 4 / tray_manager 0.7 / in_app_purchase 3.3.1 / system_date_time_format 1.5.1） | SDK + CI pin + 全量 codegen | **Low（当前）** | 与上游 CI pin 对齐故非急迫；一次性大爆炸半径，需完整重生成 + 全门禁 |
| 15 | **flutter_rust_bridge 2.13.0** | Dart+Rust 双侧 pin + 生成物 | **Low** | 无 cargo，无法重新生成 Rust 侧（rust/Cargo.toml `=2.12.0`） |
| 16 | **站点 minor 刷新**（next 16.3.x / tailwind 4.3 / next-intl 4.14 / react-query / zod / date-fns / sonner / next-auth patch） | bun update | **Medium** | `bun run lint` + 构建 + agent-browser E2E 三件套 |
| 17 | **站点 major 延后**（TS7 / prisma 7-8 / framer-motion 14 / recharts 3 / lucide 1 / mdxeditor 4 / eslint 10） | — | **Low** | 交付型站点收益低、破坏面大 |
| 18 | （否决）MSIX publisher `497b4488`、c4381a69 workflows、2dd6a79c SAF（已在基线） | — | 不适用 | 见 §2 |

执行约束提醒（来自 EXPERIENCE.md）：任何升级波改到 `app/lib/**` 文件后，必须同步站点 `src/lib/content.ts` 的 MODIFIED_FILES 白名单；生成物无关差异 checkout 回退；Rust 相关（FRB/freezed 联动）在本环境只能静态验证。

## 附：关键原始证据索引

- `git ls-remote origin refs/heads/main` → `9529e915f438...`（== 基线，2026-10-03 实测）
- `flutter pub outdated`（app/，SDK 3.41.9）→ 直接依赖 30 项带 `*`，全文存档于本报告 §3
- `curl https://pub.dev/api/packages/flutter_markdown` → `isDiscontinued: True, replacedBy: flutter_markdown_plus`
- `curl .../releases_linux.json` → current stable 3.47.6 / Dart 3.13.5 / 2026-10-01
- `flutter analyze` → No issues found!（10.2s）
- 上游 changelog 逐条：device_info_plus 13.0.0 / package_info_plus 10.0.0 / network_info_plus 8.0.0（win32 6.0 门控）、permission_handler 13.0.0（compileSdk 37）、file_picker 13.0.0（length() 可空 + 删参）、freezed 4.0.0（构造参数 final 禁用）、flex_color_picker 4.0.0（Flutter ≥3.47）、uri_content 4.0.0（Flutter 3.44）、tray_manager 0.6.0（nativeapi 重写）、wakelock_plus 1.6-1.8（Dart 3.11→Flutter 3.47 阶梯）、refena 3.6.0（纯 feat）
