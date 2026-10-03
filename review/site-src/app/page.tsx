import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { MarkdownView } from "@/components/delivery/markdown-view";
import { PatchViewer } from "@/components/delivery/patch-viewer";
import {
  MODIFIED_FILES,
  parsePatch,
  readModifiedFile,
  readOriginalReport,
  readPatch,
  readReviewReport,
} from "@/lib/content";

export default function Home() {
  const reviewReport = readReviewReport();
  const originalReport = readOriginalReport();
  const fullPatch = readPatch();
  const diffFiles = parsePatch(fullPatch);

  const stats = [
    { label: "评审引用核查", value: "79 处", desc: "两轮独立比对" },
    { label: "行号错标确认", value: "7 处", desc: "其余精确或 ±1~4 行" },
    { label: "评审团", value: "5 视角", desc: "superpowers 工作流" },
    { label: "P0 代码修复", value: "5 文件", desc: "+83 / -6 行" },
  ];

  const deliverables = [
    {
      name: "评审报告（v2.0 定稿）",
      path: "download/LocalSend传输优化总报告-评审报告.md",
      desc: "总体评判 → 逐条核实表 → 挑刺清单 → 遗漏缺陷 → 三向拓展（缺失机制 / 安全 / 上游路径）→ 修订后落地顺序 → 评审团自我修正记录",
    },
    {
      name: "P0 修复补丁",
      path: "download/localsend-p0-fixes.patch",
      desc: "git apply 可直接应用的 unified diff，含 5 个文件 +83/-6 行",
    },
    {
      name: "修改后源码副本",
      path: "download/modified-source/",
      desc: "5 个修改后文件的完整副本（源码持久化），原件在 /home/z/my-project/localsend",
    },
    {
      name: "原报告",
      path: "upload/LocalSend传输优化总报告.md",
      desc: "被评审的原始报告，未做任何改动",
    },
  ];

  const verification = [
    {
      item: "源码核查（约 60 处引用 + 40+ 处复核抽验）",
      status: "done",
      note: "对 localsend main @ 9529e915 逐条比对",
    },
    {
      item: "GitHub issue 引文核验（#144 / #427 / #850 / #2924）",
      status: "done",
      note: "标题、日期、维护者引言逐字命中",
    },
    {
      item: "5 视角 subagent 评审团反审查",
      status: "done",
      note: "v1 的 4 个新发现经攻击全部幸存；评审自身 14 处问题已修正",
    },
    {
      item: "Dart 改动编译 / 测试运行",
      status: "partial",
      note: "环境无 Flutter/Rust 工具链，已通过括号平衡与既有用例推演自查；需在装有 fvm 的环境跑 fvm flutter analyze / fvm flutter test 验证",
    },
  ];

  return (
    <div className="flex min-h-screen flex-col bg-zinc-50 dark:bg-zinc-950">
      {/* Header */}
      <header className="sticky top-0 z-10 border-b border-zinc-200 bg-white/90 backdrop-blur dark:border-zinc-800 dark:bg-zinc-950/90">
        <div className="mx-auto max-w-5xl px-4 py-4 sm:px-6">
          <div className="flex flex-wrap items-baseline justify-between gap-2">
            <h1 className="text-xl font-bold tracking-tight text-zinc-900 sm:text-2xl dark:text-zinc-50">
              LocalSend 传输优化 · 评审与修复交付
            </h1>
            <Badge variant="outline" className="border-emerald-600/50 text-emerald-700 dark:text-emerald-400">
              评审完成 · 代码已修复
            </Badge>
          </div>
          <p className="mt-1 text-sm text-zinc-500 dark:text-zinc-400">
            评审基线 localsend main @ <span className="font-mono">9529e915</span>（app 1.18.2+64）·
            与报告声称基线同一 commit
          </p>
        </div>
      </header>

      {/* Main */}
      <main className="mx-auto w-full max-w-5xl flex-1 px-4 py-6 sm:px-6">
        {/* Stats */}
        <section aria-label="关键数据" className="grid grid-cols-2 gap-3 sm:grid-cols-4">
          {stats.map((s) => (
            <Card key={s.label} className="p-4">
              <p className="text-2xl font-bold text-emerald-700 dark:text-emerald-400">{s.value}</p>
              <p className="mt-0.5 text-sm font-medium text-zinc-800 dark:text-zinc-200">{s.label}</p>
              <p className="text-xs text-zinc-500 dark:text-zinc-400">{s.desc}</p>
            </Card>
          ))}
        </section>

        {/* Content tabs */}
        <Tabs defaultValue="review" className="mt-6">
          <TabsList className="flex h-auto w-full flex-wrap justify-start gap-1 bg-zinc-100 p-1 dark:bg-zinc-800">
            <TabsTrigger value="review" className="data-[state=active]:bg-white dark:data-[state=active]:bg-zinc-950">
              评审报告 v2
            </TabsTrigger>
            <TabsTrigger value="original" className="data-[state=active]:bg-white dark:data-[state=active]:bg-zinc-950">
              原报告
            </TabsTrigger>
            <TabsTrigger value="patch" className="data-[state=active]:bg-white dark:data-[state=active]:bg-zinc-950">
              代码修改
            </TabsTrigger>
            <TabsTrigger value="delivery" className="data-[state=active]:bg-white dark:data-[state=active]:bg-zinc-950">
              交付与验证
            </TabsTrigger>
          </TabsList>

          <TabsContent value="review" className="mt-4">
            <Card className="p-4 sm:p-6">
              <MarkdownView content={reviewReport} />
            </Card>
          </TabsContent>

          <TabsContent value="original" className="mt-4">
            <Card className="p-4 sm:p-6">
              <MarkdownView content={originalReport} />
            </Card>
          </TabsContent>

          <TabsContent value="patch" className="mt-4">
            <PatchViewer files={diffFiles} fullPatch={fullPatch} modifiedFiles={MODIFIED_FILES} />
          </TabsContent>

          <TabsContent value="delivery" className="mt-4 space-y-4">
            <Card>
              <CardHeader className="pb-2">
                <CardTitle className="text-base">交付物清单（源码持久化）</CardTitle>
              </CardHeader>
              <CardContent className="space-y-3">
                {deliverables.map((d) => (
                  <div
                    key={d.path}
                    className="rounded-lg border border-zinc-100 bg-zinc-50/60 p-3 dark:border-zinc-800 dark:bg-zinc-900/50"
                  >
                    <div className="flex flex-wrap items-baseline gap-2">
                      <span className="font-semibold text-zinc-900 dark:text-zinc-100">{d.name}</span>
                      <span className="font-mono text-xs text-emerald-700 dark:text-emerald-400">{d.path}</span>
                    </div>
                    <p className="mt-1 text-sm text-zinc-600 dark:text-zinc-400">{d.desc}</p>
                  </div>
                ))}
              </CardContent>
            </Card>

            <Card>
              <CardHeader className="pb-2">
                <CardTitle className="text-base">验证状态</CardTitle>
              </CardHeader>
              <CardContent className="space-y-2">
                {verification.map((v) => (
                  <div key={v.item} className="flex items-start gap-3">
                    <Badge
                      variant="outline"
                      className={`mt-0.5 shrink-0 ${
                        v.status === "done"
                          ? "border-emerald-600/40 text-emerald-700 dark:text-emerald-400"
                          : "border-amber-500/50 text-amber-700 dark:text-amber-400"
                      }`}
                    >
                      {v.status === "done" ? "已验证" : "部分完成"}
                    </Badge>
                    <div>
                      <p className="text-sm font-medium text-zinc-800 dark:text-zinc-200">{v.item}</p>
                      <p className="text-sm text-zinc-500 dark:text-zinc-400">{v.note}</p>
                    </div>
                  </div>
                ))}
              </CardContent>
            </Card>

            <Card>
              <CardHeader className="pb-2">
                <CardTitle className="text-base">修复摘要（对应评审结论）</CardTitle>
              </CardHeader>
              <CardContent className="space-y-2">
                {MODIFIED_FILES.map((f) => {
                  const content = readModifiedFile(f.path);
                  return (
                    <details
                      key={f.path}
                      className="rounded-lg border border-zinc-100 bg-zinc-50/60 dark:border-zinc-800 dark:bg-zinc-900/50"
                    >
                      <summary className="cursor-pointer px-3 py-2 text-sm font-medium text-zinc-800 dark:text-zinc-200">
                        {f.label} · <span className="font-mono text-xs text-zinc-500">{f.path}</span>
                        <span className="ml-2 text-xs text-zinc-400">（{content.split("\n").length} 行）</span>
                      </summary>
                      <pre className="overflow-x-auto border-t border-zinc-100 p-3 font-mono text-[11.5px] leading-5 text-zinc-700 dark:border-zinc-800 dark:text-zinc-300">
                        {content}
                      </pre>
                    </details>
                  );
                })}
              </CardContent>
            </Card>
          </TabsContent>
        </Tabs>
      </main>

      {/* Sticky footer */}
      <footer className="mt-auto border-t border-zinc-200 bg-white py-4 dark:border-zinc-800 dark:bg-zinc-950">
        <div className="mx-auto max-w-5xl px-4 text-center text-xs text-zinc-500 sm:px-6 dark:text-zinc-400">
          LocalSend 传输优化总报告 · 独立评审 v2.0 · 5 视角评审团（superpowers）· P0 修复 5 文件 ·
          源码持久化于 download/ 与 localsend/
        </div>
      </footer>
    </div>
  );
}
