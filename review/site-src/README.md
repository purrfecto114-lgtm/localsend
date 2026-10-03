# site-src — 源码储存站 v2 站点源码

Next.js 16 单页应用（3 tab 精简版）的自定义源文件，共 5 个。脚手架本身
（package.json / tailwind / shadcn-ui 组件等）由 fullstack-dev 技能初始化。

## 文件 → 目标路径映射

| 本目录路径 | 放回脚手架的路径 |
|---|---|
| `app/page.tsx` | `src/app/page.tsx` |
| `app/layout.tsx` | `src/app/layout.tsx` |
| `lib/content.ts` | `src/lib/content.ts` |
| `components/delivery/markdown-view.tsx` | `src/components/delivery/markdown-view.tsx` |
| `components/delivery/source-browser.tsx` | `src/components/delivery/source-browser.tsx` |

## 恢复步骤

1. 用 fullstack-dev 技能初始化 Next.js 16 + TS + Tailwind 4 + shadcn/ui 脚手架。
2. 按上表把 5 个文件放回对应路径（覆盖脚手架默认 page.tsx / layout.tsx）。
3. `bun add remark-gfm`（react-markdown 脚手架自带，remark-gfm 需补装）。
4. **路径依赖**：`lib/content.ts` 的数据源为本地 git 克隆
   `/home/z/my-project/localsend`（fork main 分支，含 review/ 存档与修复后源码）
   与 `/home/z/my-project/download/release-info.json`（Release 清单，运行时生成）。
   若克隆位于其他路径，修改 `REPO_ROOT` 常量即可；release-info.json 缺失时
   站点显示确定性的"待发布"预置状态，不影响渲染。
5. `bun dev`（端口 3000）→ `bun run lint` → agent-browser 端到端验证。

## 站点结构（v2 · 3 tab）

- **源码**：仓库实时 git 状态卡（execSync 读 branch/HEAD/工作树/log）+
  5 个修复文件的源码浏览器（完整源码带行号 ↔ Diff 双模式切换）。
- **评审报告**：react-markdown 渲染 review-report/ 下的 v2.0 定稿。
- **发布与交付**：Release 清单表（产物/说明/大小/下载链接，读
  release-info.json）+ 实际进度（已完成/待办/明确不做）+ 静态验证证据 +
  原报告（details 折叠，完整渲染）。
- 内容全部服务端磁盘读取（fork main 克隆），不硬编码进前端组件——
  替换仓库内容或 release-info.json 后站点自动更新。
- v1（4 tab 交付站）的 patch-viewer.tsx 已被 source-browser.tsx 取代
  （补丁解析逻辑 parsePatch 保留在 content.ts）。

## 验证存档

`../deliverables/preview-site-v2-*.png`：源码 tab / 评审报告 tab /
发布与交付 tab / 390px 移动端 四张浏览器验证截图（2026-10-03）。
