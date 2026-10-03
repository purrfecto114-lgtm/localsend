"use client";

import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import type { DiffFile } from "@/lib/content";
import { useState } from "react";

function DiffLineRow({
  type,
  text,
  oldNo,
  newNo,
}: {
  type: string;
  text: string;
  oldNo?: number;
  newNo?: number;
}) {
  let rowClass = "";
  let signBg = "";
  if (type === "add") {
    rowClass = "bg-emerald-50 dark:bg-emerald-950/40";
    signBg = "text-emerald-700 dark:text-emerald-400";
  } else if (type === "del") {
    rowClass = "bg-red-50 dark:bg-red-950/40";
    signBg = "text-red-700 dark:text-red-400";
  } else if (type === "hunk") {
    rowClass = "bg-amber-50 text-amber-800 dark:bg-amber-950/40 dark:text-amber-300";
  } else if (type === "meta") {
    rowClass = "text-zinc-400 dark:text-zinc-600";
  }

  return (
    <div className={`flex font-mono text-[12px] leading-5 ${rowClass}`}>
      <span className="w-10 shrink-0 select-none border-r border-zinc-200 pr-1.5 text-right text-zinc-400 dark:border-zinc-700 dark:text-zinc-600">
        {oldNo ?? ""}
      </span>
      <span className="w-10 shrink-0 select-none border-r border-zinc-200 pr-1.5 text-right text-zinc-400 dark:border-zinc-700 dark:text-zinc-600">
        {newNo ?? ""}
      </span>
      <span className={`w-5 shrink-0 select-none text-center ${signBg}`}>
        {type === "add" ? "+" : type === "del" ? "-" : type === "hunk" ? "@" : " "}
      </span>
      <span className="whitespace-pre-wrap break-all pr-4 text-zinc-800 dark:text-zinc-200">{text}</span>
    </div>
  );
}

function DiffFileCard({ file }: { file: DiffFile }) {
  return (
    <Card className="overflow-hidden">
      <CardHeader className="pb-3">
        <CardTitle className="flex flex-wrap items-center gap-2 font-mono text-[13px] font-medium">
          <span className="text-zinc-800 dark:text-zinc-200">{file.file}</span>
          <Badge variant="outline" className="border-emerald-600/40 text-emerald-700 dark:text-emerald-400">
            +{file.additions}
          </Badge>
          <Badge variant="outline" className="border-red-400/50 text-red-700 dark:text-red-400">
            -{file.deletions}
          </Badge>
        </CardTitle>
      </CardHeader>
      <CardContent className="p-0">
        <div className="overflow-x-auto border-t border-zinc-200 dark:border-zinc-700">
          <div className="min-w-max">
            {file.lines.map((line, i) => (
              <DiffLineRow key={i} type={line.type} text={line.text} oldNo={line.oldNo} newNo={line.newNo} />
            ))}
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

interface PatchViewerProps {
  files: DiffFile[];
  fullPatch: string;
  modifiedFiles: readonly { path: string; label: string; fix: string }[];
}

export function PatchViewer({ files, fullPatch, modifiedFiles }: PatchViewerProps) {
  const [selected, setSelected] = useState<string>(files[0]?.file ?? "");

  const current = files.find((f) => f.file === selected);

  return (
    <div className="space-y-4">
      <Card>
        <CardHeader className="pb-2">
          <CardTitle className="text-base">修改清单（5 个文件，+83 / -6）</CardTitle>
        </CardHeader>
        <CardContent className="space-y-2">
          {modifiedFiles.map((f) => (
            <div key={f.path} className="flex flex-wrap items-center gap-2 rounded-md border border-zinc-100 bg-zinc-50/60 px-3 py-2 text-sm dark:border-zinc-800 dark:bg-zinc-900/50">
              <Badge variant="secondary" className="shrink-0 bg-emerald-100 text-emerald-800 dark:bg-emerald-900/50 dark:text-emerald-300">
                {f.fix}
              </Badge>
              <span className="font-medium text-zinc-800 dark:text-zinc-200">{f.label}</span>
              <span className="font-mono text-xs text-zinc-500">{f.path}</span>
            </div>
          ))}
        </CardContent>
      </Card>

      <Tabs value={selected} onValueChange={setSelected}>
        <TabsList className="flex h-auto w-full flex-wrap justify-start gap-1 bg-zinc-100 p-1 dark:bg-zinc-800">
          {files.map((f) => (
            <TabsTrigger
              key={f.file}
              value={f.file}
              className="h-8 max-w-full shrink basis-auto px-3 font-mono text-[11px] data-[state=active]:bg-white dark:data-[state=active]:bg-zinc-950"
            >
              <span className="truncate">{f.file.split("/").pop()}</span>
            </TabsTrigger>
          ))}
        </TabsList>
        {files.map((f) => (
          <TabsContent key={f.file} value={f.file} className="mt-3">
            {current ? <DiffFileCard file={f} /> : null}
          </TabsContent>
        ))}
      </Tabs>

      <Card>
        <CardHeader className="pb-2">
          <CardTitle className="text-base">完整补丁文件（可直接 git apply）</CardTitle>
        </CardHeader>
        <CardContent>
          <ScrollArea className="h-64 rounded-md border border-zinc-800 bg-zinc-900">
            <pre className="p-4 font-mono text-[11.5px] leading-5 text-zinc-300">{fullPatch}</pre>
          </ScrollArea>
        </CardContent>
      </Card>
    </div>
  );
}
