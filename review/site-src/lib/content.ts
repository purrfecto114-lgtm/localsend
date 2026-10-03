import fs from "fs";
import path from "path";

/**
 * Server-side content loader.
 * All deliverables are persisted on disk (source-of-truth), and read at
 * request time so that updates to the files are reflected immediately.
 */

const DOWNLOAD_DIR = "/home/z/my-project/download";

export const REVIEW_REPORT_PATH = path.join(
  DOWNLOAD_DIR,
  "LocalSend传输优化总报告-评审报告.md",
);
export const ORIGINAL_REPORT_PATH = path.join(
  DOWNLOAD_DIR,
  "..",
  "upload",
  "LocalSend传输优化总报告.md",
);
export const PATCH_PATH = path.join(DOWNLOAD_DIR, "localsend-p0-fixes.patch");

export function readTextFile(filePath: string): string {
  try {
    return fs.readFileSync(filePath, "utf-8");
  } catch (err) {
    console.error(`Failed to read ${filePath}:`, err);
    return `> ⚠️ 文件读取失败：${path.basename(filePath)}。请确认文件已持久化到 download/ 目录。`;
  }
}

export function readReviewReport(): string {
  return readTextFile(REVIEW_REPORT_PATH);
}

export function readOriginalReport(): string {
  return readTextFile(ORIGINAL_REPORT_PATH);
}

export function readPatch(): string {
  return readTextFile(PATCH_PATH);
}

export interface DiffFile {
  file: string;
  header: string;
  lines: DiffLine[];
  additions: number;
  deletions: number;
}

export interface DiffLine {
  type: "add" | "del" | "hunk" | "meta" | "context";
  text: string;
  oldNo?: number;
  newNo?: number;
}

/** Parse a unified diff into per-file structures for rendering. */
export function parsePatch(patch: string): DiffFile[] {
  const files: DiffFile[] = [];
  const rawFiles = patch.split(/^diff --git /m).filter((s) => s.trim().length > 0);

  for (const raw of rawFiles) {
    const lines = raw.split("\n");
    // First line of the chunk is the "a/... b/..." part of "diff --git"
    const gitLine = "diff --git " + (lines[0] ?? "");
    const match = gitLine.match(/^diff --git a\/(.+?) b\/(.+)$/);
    const filePath = match ? match[2] : "unknown";
    let additions = 0;
    let deletions = 0;
    const parsed: DiffLine[] = [];
    let oldNo = 0;
    let newNo = 0;

    for (let i = 1; i < lines.length; i++) {
      const line = lines[i];
      if (line.startsWith("index ")) {
        parsed.push({ type: "meta", text: line });
      } else if (line.startsWith("--- ")) {
        parsed.push({ type: "meta", text: line });
      } else if (line.startsWith("+++ ")) {
        parsed.push({ type: "meta", text: line });
      } else if (line.startsWith("@@")) {
        const hunk = line.match(/^@@ -(\d+)(?:,\d+)? \+(\d+)(?:,\d+)? @@/);
        if (hunk) {
          oldNo = parseInt(hunk[1], 10);
          newNo = parseInt(hunk[2], 10);
        }
        parsed.push({ type: "hunk", text: line });
      } else if (line.startsWith("+")) {
        additions++;
        parsed.push({ type: "add", text: line.slice(1), newNo: newNo++ });
      } else if (line.startsWith("-")) {
        deletions++;
        parsed.push({ type: "del", text: line.slice(1), oldNo: oldNo++ });
      } else if (line.startsWith(" ")) {
        parsed.push({ type: "context", text: line.slice(1), oldNo: oldNo++, newNo: newNo++ });
      } else if (line.length === 0) {
        // ignore trailing empty line
      } else {
        parsed.push({ type: "context", text: line, oldNo: oldNo++, newNo: newNo++ });
      }
    }

    files.push({ file: filePath, header: gitLine, lines: parsed, additions, deletions });
  }

  return files;
}

/** Copy the modified source files out of the localsend clone for persistence. */
export const MODIFIED_FILES = [
  { path: "app/lib/main.dart", label: "Fix 4 · Android resumed 发现重绑", fix: "机制 1" },
  {
    path: "app/lib/provider/settings_provider.dart",
    label: "Fix 1 · 设置变更触发 discovery 重启",
    fix: "新缺陷 1",
  },
  {
    path: "app/lib/provider/local_ip_provider.dart",
    label: "Fix 2 · .1 排序例外 / Windows 轮询 / 接口变化重绑",
    fix: "机制 1 + 机制 4",
  },
  {
    path: "app/lib/provider/network/scan_facade.dart",
    label: "Fix 3 · maxInterfaces 3 → 5",
    fix: "机制 4",
  },
  {
    path: "app/test/unit/provider/network_info_provider_test.dart",
    label: "Fix 5 · 排序测试同步更新（+3 用例）",
    fix: "回归风险 C-1",
  },
] as const;

export function readModifiedFile(relPath: string): string {
  return readTextFile(path.join("/home/z/my-project/localsend", relPath));
}
