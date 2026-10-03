"use client";

import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import type { DiffFile } from "@/lib/content";
import { useState } from "react";

export interface SourceFileData {
  path: string;
  label: string;
  fix: string;
  content: string;
  diff: DiffFile;
}

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
  let signColor = "";
  if (type === "add") {
    rowClass = "bg-emerald-50 dark:bg-emerald-950/40";
    signColor = "text-emerald-700 dark:text-emerald-400";
  } else if (type === "del") {
    rowClass = "bg-red-50 dark:bg-red-950/40";
    signColor = "text-red-700 dark:text-red-400";
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
      <span className={`w-5 shrink-0 select-none text-center ${signColor}`}>
        {type === "add" ? "+" : type === "del" ? "-" : type === "hunk" ? "@" : " "}
      </span>
      <span className="whitespace-pre-wrap break-all pr-4 text-zinc-800 dark:text-zinc-200">{text}</span>
    </div>
  );
}

function SourceView({ content }: { content: string }) {
  const lines = content.split("\n");
  return (
    <div className="max-h-[70vh] overflow-auto rounded-md border border-zinc-200 bg-zinc-50/60 dark:border-zinc-800 dark:bg-zinc-900/40">
      {lines.map((line, i) => (
        <div key={i} className="flex hover:bg-zinc-100/70 dark:hover:bg-zinc-800/40">
          <span className="w-12 shrink-0 select-none border-r border-zinc-200 px-2 text-right font-mono text-[11px] leading-5 text-zinc-400 dark:border-zinc-700 dark:text-zinc-600">
            {i + 1}
          </span>
          <pre className="flex-1 whitespace-pre px-3 font-mono text-[12px] leading-5 text-zinc-800 dark:text-zinc-200">
            {line || " "}
          </pre>
        </div>
      ))}
    </div>
  );
}

function DiffView({ diff }: { diff: DiffFile }) {
  return (
    <div className="max-h-[70vh] overflow-auto rounded-md border border-zinc-200 dark:border-zinc-800">
      <div className="min-w-max">
        {diff.lines.map((line, i) => (
          <DiffLineRow key={i} type={line.type} text={line.text} oldNo={line.oldNo} newNo={line.newNo} />
        ))}
      </div>
    </div>
  );
}

export function SourceBrowser({ files }: { files: SourceFileData[] }) {
  const [selected, setSelected] = useState(0);
  const [mode, setMode] = useState<"source" | "diff">("source");

  const current = files[selected];
  if (!current) return null;
  const lineCount = current.content.split("\n").length;

  return (
    <div className="space-y-3">
      {/* File selector */}
      <div className="flex gap-1.5 overflow-x-auto pb-1" role="tablist" aria-label="源文件选择">
        {files.map((f, i) => (
          <button
            key={f.path}
            role="tab"
            aria-selected={i === selected}
            onClick={() => setSelected(i)}
            className={`shrink-0 rounded-md border px-3 py-1.5 font-mono text-xs transition-colors ${
              i === selected
                ? "border-emerald-600/50 bg-emerald-50 text-emerald-800 dark:bg-emerald-950/40 dark:text-emerald-300"
                : "border-zinc-200 bg-white text-zinc-600 hover:bg-zinc-50 dark:border-zinc-800 dark:bg-zinc-950 dark:text-zinc-400 dark:hover:bg-zinc-900"
            }`}
          >
            {f.path.split("/").pop()}
          </button>
        ))}
      </div>

      {/* Active file header */}
      <Card className="p-3">
        <div className="flex flex-wrap items-center justify-between gap-2">
          <div className="flex flex-wrap items-center gap-2">
            <Badge variant="secondary" className="bg-emerald-100 text-emerald-800 dark:bg-emerald-900/50 dark:text-emerald-300">
              {current.fix}
            </Badge>
            <span className="text-sm font-medium text-zinc-800 dark:text-zinc-200">{current.label}</span>
            <span className="font-mono text-xs text-zinc-500 dark:text-zinc-400">{current.path}</span>
          </div>
          <div className="flex items-center gap-2">
            <span className="font-mono text-xs text-zinc-400 dark:text-zinc-500">
              {mode === "source" ? `${lineCount} 行` : `+${current.diff.additions} −${current.diff.deletions}`}
            </span>
            <div className="flex rounded-md border border-zinc-200 p-0.5 dark:border-zinc-700" role="group" aria-label="视图切换">
              <button
                onClick={() => setMode("source")}
                aria-pressed={mode === "source"}
                className={`rounded px-2.5 py-1 text-xs font-medium transition-colors ${
                  mode === "source"
                    ? "bg-zinc-800 text-white dark:bg-zinc-200 dark:text-zinc-900"
                    : "text-zinc-500 hover:text-zinc-800 dark:text-zinc-400 dark:hover:text-zinc-200"
                }`}
              >
                完整源码
              </button>
              <button
                onClick={() => setMode("diff")}
                aria-pressed={mode === "diff"}
                className={`rounded px-2.5 py-1 text-xs font-medium transition-colors ${
                  mode === "diff"
                    ? "bg-zinc-800 text-white dark:bg-zinc-200 dark:text-zinc-900"
                    : "text-zinc-500 hover:text-zinc-800 dark:text-zinc-400 dark:hover:text-zinc-200"
                }`}
              >
                Diff
              </button>
            </div>
          </div>
        </div>
      </Card>

      {/* Content */}
      {mode === "source" ? <SourceView content={current.content} /> : <DiffView diff={current.diff} />}
    </div>
  );
}
