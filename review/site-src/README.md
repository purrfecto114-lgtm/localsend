# site-src — 交付站点恢复说明

本目录存放 Next.js 16 交付站点（4 tab 单页应用）的**自定义源文件**，共 5 个。
脚手架本身（package.json / tailwind / shadcn-ui 组件等）由 fullstack-dev 技能
初始化，不在打包范围内。

## 文件 → 目标路径映射

| 本包路径 | 放回脚手架的路径 |
|---|---|
| `app/page.tsx` | `src/app/page.tsx` |
| `app/layout.tsx` | `src/app/layout.tsx` |
| `lib/content.ts` | `src/lib/content.ts` |
| `components/delivery/markdown-view.tsx` | `src/components/delivery/markdown-view.tsx` |
| `components/delivery/patch-viewer.tsx` | `src/components/delivery/patch-viewer.tsx` |

## 恢复步骤

1. 用 fullstack-dev 技能初始化 Next.js 16 + TS + Tailwind 4 + shadcn/ui 脚手架。
2. 按上表把 5 个文件放回对应路径（覆盖脚手架默认 page.tsx / layout.tsx）。
3. `bun add remark-gfm`（react-markdown 脚手架自带，remark-gfm 需补装）。
4. **改路径**：`lib/content.ts` 服务端从磁盘读取交付物（评审报告 / 补丁 /
   modified-source / 原报告）。把其中的基准路径改成实际解压位置——例如交接包
   解压在 `/home/z/my-project/`，则指向
   `/home/z/my-project/localsend-review-handoff/deliverables/` 与
   `original-report/`。
5. `bun dev`（端口 3000）→ `bunx eslint src/` → agent-browser 端到端验证
   （先例 Task 7：4 tab 渲染、390px 移动端、console 无错误）。

## 站点结构速记

- 4 个 tab：评审报告 v2（react-markdown 渲染）/ 原报告 / 代码修改
  （patch-viewer：文件 tab + 行号 + 增删行着色）/ 交付与验证（关键数据卡片 +
  交付物清单 + 验证状态）。
- 内容全部服务端磁盘读取，不硬编码进前端组件——替换交付物后站点自动更新。
- 验证截图见 deliverables/preview-*.png（本站点在上一会话的浏览器验证存档）。
