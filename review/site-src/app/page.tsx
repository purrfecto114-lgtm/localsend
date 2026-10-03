import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { MarkdownView } from "@/components/delivery/markdown-view";
import { SourceBrowser, type SourceFileData } from "@/components/delivery/source-browser";
import {
  BASE_COMMIT,
  FIX_COMMIT,
  MODIFIED_FILES,
  REPO_URL,
  RELEASE_TAG,
  UPSTREAM_URL,
  parsePatch,
  readOriginalReport,
  readPatch,
  readReleaseInfo,
  readRepoState,
  readReviewReport,
  readSourceFile,
} from "@/lib/content";

export default function Home() {
  const repo = readRepoState();
  const release = readReleaseInfo();
  const reviewReport = readReviewReport();
  const originalReport = readOriginalReport();
  const diffFiles = parsePatch(readPatch());

  const files: SourceFileData[] = MODIFIED_FILES.map((m) => ({
    ...m,
    content: readSourceFile(m.path),
    diff:
      diffFiles.find((d) => d.file === m.path) ?? {
        file: m.path,
        header: "",
        lines: [],
        additions: 0,
        deletions: 0,
      },
  }));

  const formatSize = (bytes?: number) => {
    if (bytes == null) return "—";
    if (bytes < 1024) return `${bytes} B`;
    if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`;
    return `${(bytes / 1024 / 1024).toFixed(2)} MB`;
  };

  const progress = {
    done: [
      "评审主链路：79 处引用两轮核查 → 5 视角评审团反审查（43 条意见）→ 评审报告 v2 定稿",
      "P0 修复：5 文件 +83/−6，MD5 全链路校验（交付记录 ↔ main 合并树逐字节一致）",
      `远端持久化：fork main（基线 ${BASE_COMMIT.slice(0, 8)} + 修复 ${FIX_COMMIT.slice(0, 8)} + review/ 存档）`,
      `Release ${RELEASE_TAG} 发布（5 产物：补丁 / 评审报告 / 原报告 / 源码 zip / 存档 zip）`,
      "源码储存站 v2（本站点，3 tab 精简重构）",
    ],
    pending: [
      "Flutter 工具链验证：fvm flutter analyze && fvm flutter test app/test/unit/provider/network_info_provider_test.dart（预期 7 用例全绿）—— 需在有工具链的环境执行",
      "空壳仓库 purrfecto114-lgtm/localsend-review 清理 —— token 无 Administration 删除权限，需手动处理",
    ],
    blocked: ["上游 issue/PR：owner 明确指示「验证完成前不提交」，暂缓（评审 Task 3-e 已给出合规序列）"],
  };

  return (
    <div className="flex min-h-screen flex-col bg-zinc-50 dark:bg-zinc-950">
      {/* Header */}
      <header className="sticky top-0 z-10 border-b border-zinc-200 bg-white/90 backdrop-blur dark:border-zinc-800 dark:bg-zinc-950/90">
        <div className="mx-auto max-w-5xl px-4 py-4 sm:px-6">
          <div className="flex flex-wrap items-baseline justify-between gap-2">
            <h1 className="text-xl font-bold tracking-tight text-zinc-900 sm:text-2xl dark:text-zinc-50">
              LocalSend P0 · 源码储存站
            </h1>
            <div className="flex flex-wrap gap-1.5">
              <a
                href={REPO_URL}
                target="_blank"
                rel="noreferrer"
                className="rounded-md border border-zinc-200 px-2 py-0.5 text-xs text-zinc-600 transition-colors hover:bg-zinc-100 dark:border-zinc-700 dark:text-zinc-400 dark:hover:bg-zinc-900"
              >
                fork main ↗
              </a>
              <a
                href={release.html_url}
                target="_blank"
                rel="noreferrer"
                className="rounded-md border border-emerald-600/40 px-2 py-0.5 text-xs text-emerald-700 transition-colors hover:bg-emerald-50 dark:text-emerald-400 dark:hover:bg-emerald-950/40"
              >
                {RELEASE_TAG} ↗
              </a>
            </div>
          </div>
          <p className="mt-1 text-sm text-zinc-500 dark:text-zinc-400">
            基线 <span className="font-mono">{BASE_COMMIT.slice(0, 8)}</span> · P0 修复{" "}
            <span className="font-mono">{FIX_COMMIT.slice(0, 8)}</span>（5 文件 +83/−6）· 上游未动 ·
            未提交上游 PR（待验证）
          </p>
        </div>
      </header>

      {/* Main */}
      <main className="mx-auto w-full max-w-5xl flex-1 px-4 py-6 sm:px-6">
        <Tabs defaultValue="source">
          <TabsList className="flex h-auto w-full flex-wrap justify-start gap-1 bg-zinc-100 p-1 dark:bg-zinc-800">
            <TabsTrigger value="source" className="data-[state=active]:bg-white dark:data-[state=active]:bg-zinc-950">
              源码
            </TabsTrigger>
            <TabsTrigger value="review" className="data-[state=active]:bg-white dark:data-[state=active]:bg-zinc-950">
              评审报告
            </TabsTrigger>
            <TabsTrigger value="release" className="data-[state=active]:bg-white dark:data-[state=active]:bg-zinc-950">
              发布与交付
            </TabsTrigger>
          </TabsList>

          {/* Tab 1: Source */}
          <TabsContent value="source" className="mt-4 space-y-4">
            <Card className="p-4">
              <div className="grid gap-3 sm:grid-cols-2">
                <div className="space-y-1">
                  <p className="text-xs font-medium uppercase tracking-wide text-zinc-400 dark:text-zinc-500">
                    仓库状态（实时 git）
                  </p>
                  <div className="space-y-1 font-mono text-xs text-zinc-600 dark:text-zinc-300">
                    <p>
                      branch <span className="text-emerald-700 dark:text-emerald-400">{repo.branch}</span> ·
                      HEAD <span className="text-emerald-700 dark:text-emerald-400">{repo.headShort}</span> ·
                      工作树 {repo.clean ? "clean" : "dirty"}
                    </p>
                    {repo.log.slice(0, 4).map((c) => (
                      <p key={c.sha} className="truncate text-zinc-500 dark:text-zinc-400">
                        {c.sha} {c.message}
                      </p>
                    ))}
                  </div>
                </div>
                <div className="space-y-1">
                  <p className="text-xs font-medium uppercase tracking-wide text-zinc-400 dark:text-zinc-500">
                    源码构成
                  </p>
                  <ul className="space-y-1 text-xs text-zinc-600 dark:text-zinc-300">
                    <li>
                      · <span className="font-mono">{BASE_COMMIT.slice(0, 8)}</span> 上游基线（
                      <a href={UPSTREAM_URL} target="_blank" rel="noreferrer" className="underline decoration-dotted">
                        localsend/localsend
                      </a>{" "}
                      main，app 1.18.2+64）
                    </li>
                    <li>
                      · <span className="font-mono">{FIX_COMMIT.slice(0, 8)}</span> P0 修复（5 文件 +83/−6，fork PR #1 合并）
                    </li>
                    <li>· review/ 评审存档 + .github/workflows/release.yml</li>
                    <li>· 以下浏览器展示 5 个修复文件的完整源码与 diff（服务端磁盘读取）</li>
                  </ul>
                </div>
              </div>
            </Card>

            <SourceBrowser files={files} />
          </TabsContent>

          {/* Tab 2: Review report */}
          <TabsContent value="review" className="mt-4">
            <Card className="p-4 sm:p-6">
              <MarkdownView content={reviewReport} />
            </Card>
          </TabsContent>

          {/* Tab 3: Release & delivery */}
          <TabsContent value="release" className="mt-4 space-y-4">
            <Card>
              <CardHeader className="pb-2">
                <CardTitle className="flex flex-wrap items-center gap-2 text-base">
                  Release {release.tag}
                  <Badge
                    variant="outline"
                    className={
                      release.pending
                        ? "border-amber-500/50 text-amber-700 dark:text-amber-400"
                        : "border-emerald-600/50 text-emerald-700 dark:text-emerald-400"
                    }
                  >
                    {release.pending ? "待发布" : "已发布"}
                  </Badge>
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-3">
                <a
                  href={release.html_url}
                  target="_blank"
                  rel="noreferrer"
                  className="block font-mono text-xs text-emerald-700 underline decoration-dotted dark:text-emerald-400"
                >
                  {release.html_url}
                </a>
                <div className="overflow-x-auto rounded-md border border-zinc-100 dark:border-zinc-800">
                  <table className="w-full text-sm">
                    <thead>
                      <tr className="border-b border-zinc-100 bg-zinc-50/60 text-left text-xs text-zinc-500 dark:border-zinc-800 dark:bg-zinc-900/50 dark:text-zinc-400">
                        <th className="px-3 py-2 font-medium">产物</th>
                        <th className="px-3 py-2 font-medium">说明</th>
                        <th className="px-3 py-2 font-medium">大小</th>
                      </tr>
                    </thead>
                    <tbody>
                      {release.assets.map((a) => (
                        <tr key={a.name} className="border-b border-zinc-50 last:border-0 dark:border-zinc-900">
                          <td className="px-3 py-2">
                            <a
                              href={a.url}
                              target="_blank"
                              rel="noreferrer"
                              className="font-mono text-xs text-emerald-700 underline decoration-dotted dark:text-emerald-400"
                            >
                              {a.name}
                            </a>
                          </td>
                          <td className="px-3 py-2 text-xs text-zinc-600 dark:text-zinc-400">{a.label}</td>
                          <td className="px-3 py-2 font-mono text-xs text-zinc-500 dark:text-zinc-500">
                            {formatSize(a.size)}
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
                <p className="text-xs text-zinc-400 dark:text-zinc-500">
                  产物亦可通过 workflow 重建：推 <span className="font-mono">p0-review-*</span> tag 或手动 dispatch{" "}
                  <span className="font-mono">.github/workflows/release.yml</span>（--clobber 幂等刷新）
                </p>
              </CardContent>
            </Card>

            <Card>
              <CardHeader className="pb-2">
                <CardTitle className="text-base">实际进度（实时核验）</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div>
                  <p className="mb-2 text-xs font-medium uppercase tracking-wide text-emerald-700 dark:text-emerald-400">
                    已完成
                  </p>
                  <ul className="space-y-1.5">
                    {progress.done.map((item) => (
                      <li key={item} className="flex gap-2 text-sm text-zinc-600 dark:text-zinc-300">
                        <span className="text-emerald-600 dark:text-emerald-400">✓</span>
                        {item}
                      </li>
                    ))}
                  </ul>
                </div>
                <div>
                  <p className="mb-2 text-xs font-medium uppercase tracking-wide text-amber-600 dark:text-amber-400">
                    待办
                  </p>
                  <ul className="space-y-1.5">
                    {progress.pending.map((item) => (
                      <li key={item} className="flex gap-2 text-sm text-zinc-600 dark:text-zinc-300">
                        <span className="text-amber-600 dark:text-amber-400">⏳</span>
                        {item}
                      </li>
                    ))}
                  </ul>
                </div>
                <div>
                  <p className="mb-2 text-xs font-medium uppercase tracking-wide text-zinc-400 dark:text-zinc-500">
                    明确不做（owner 决策）
                  </p>
                  <ul className="space-y-1.5">
                    {progress.blocked.map((item) => (
                      <li key={item} className="flex gap-2 text-sm text-zinc-500 dark:text-zinc-400">
                        <span>⛔</span>
                        {item}
                      </li>
                    ))}
                  </ul>
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardHeader className="pb-2">
                <CardTitle className="text-base">静态验证证据</CardTitle>
              </CardHeader>
              <CardContent>
                <ul className="space-y-1.5 text-sm text-zinc-600 dark:text-zinc-300">
                  <li>· 补丁 <span className="font-mono text-xs">git apply --check</span> 对基线干净通过（恰 5 个 M 文件）</li>
                  <li>· main 合并树 5 文件 MD5 与交付记录逐字节一致</li>
                  <li>· 测试文件 7 用例（旧 4 + 新 3）；Dart 括号平衡静态检查 5/5 通过</li>
                  <li>
                    · ⚠️ 未经 Flutter 工具链验证（编写环境无 cargo/rustc/flutter/fvm）—— 这是待办第一项的原因
                  </li>
                </ul>
              </CardContent>
            </Card>

            <details className="rounded-lg border border-zinc-200 dark:border-zinc-800">
              <summary className="cursor-pointer px-4 py-3 text-sm font-medium text-zinc-800 dark:text-zinc-200">
                原报告（被评审原件 · {originalReport.split("\n").length} 行 · 未改动）
              </summary>
              <div className="border-t border-zinc-100 p-4 dark:border-zinc-800">
                <MarkdownView content={originalReport} />
              </div>
            </details>
          </TabsContent>
        </Tabs>
      </main>

      {/* Sticky footer */}
      <footer className="mt-auto border-t border-zinc-200 bg-white py-4 dark:border-zinc-800 dark:bg-zinc-950">
        <div className="mx-auto max-w-5xl px-4 text-center text-xs text-zinc-500 sm:px-6 dark:text-zinc-400">
          源码储存站 · 内容服务端磁盘读取（fork main 克隆）· 基线 {BASE_COMMIT.slice(0, 8)} · 修复{" "}
          {FIX_COMMIT.slice(0, 8)} · Release {RELEASE_TAG} · 上游未动
        </div>
      </footer>
    </div>
  );
}
