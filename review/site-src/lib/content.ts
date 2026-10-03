import { execSync } from "child_process";
import fs from "fs";
import path from "path";

/**
 * Server-side content loader for the source storage station.
 *
 * Single source of truth: the git clone of the fork at
 * /home/z/my-project/localsend (branch main). All artifacts (review
 * archive, patch, source files) are read from the repo working tree at
 * request time, plus a runtime release manifest on disk.
 */

const REPO_ROOT = "/home/z/my-project/localsend";
const REVIEW_DIR = path.join(REPO_ROOT, "review");
const RELEASE_INFO_PATH = "/home/z/my-project/download/release-info.json";

export const REPO_URL = "https://github.com/purrfecto114-lgtm/localsend";
export const UPSTREAM_URL = "https://github.com/localsend/localsend";
export const BASE_COMMIT = "9529e915f438d8edd8bdf23e9f7aab2261a8b3e6";
export const FIX_COMMIT = "9a66108032ca";
export const RELEASE_TAG = "p0-review-v1";

export function readTextFile(filePath: string): string {
  try {
    return fs.readFileSync(filePath, "utf-8");
  } catch (err) {
    console.error(`Failed to read ${filePath}:`, err);
    return `> ⚠️ 文件读取失败：${path.basename(filePath)}。请确认仓库克隆位于 ${REPO_ROOT}（main 分支）。`;
  }
}

/* ---------------- Repo state (live git) ---------------- */

export interface RepoState {
  head: string;
  headShort: string;
  branch: string;
  clean: boolean;
  log: { sha: string; message: string }[];
}

export function readRepoState(): RepoState {
  try {
    const head = execSync("git rev-parse HEAD", { cwd: REPO_ROOT, encoding: "utf-8" }).trim();
    const branch = execSync("git rev-parse --abbrev-ref HEAD", { cwd: REPO_ROOT, encoding: "utf-8" }).trim();
    const status = execSync("git status --short", { cwd: REPO_ROOT, encoding: "utf-8" }).trim();
    const log = execSync("git log --pretty=format:'%h|%s' -6", { cwd: REPO_ROOT, encoding: "utf-8" })
      .trim()
      .split("\n")
      .map((line) => {
        const [sha, ...rest] = line.split("|");
        return { sha, message: rest.join("|") };
      });
    return { head, headShort: head.slice(0, 10), branch, clean: status.length === 0, log };
  } catch (err) {
    console.error("Failed to read git state:", err);
    return { head: "unknown", headShort: "unknown", branch: "unknown", clean: false, log: [] };
  }
}

/* ---------------- Review archive (in-repo) ---------------- */

export function readReviewReport(): string {
  return readTextFile(path.join(REVIEW_DIR, "review-report", "LocalSend传输优化总报告-评审报告.md"));
}

export function readOriginalReport(): string {
  return readTextFile(path.join(REVIEW_DIR, "original-report", "LocalSend传输优化总报告.md"));
}

export function readPatch(): string {
  return readTextFile(path.join(REVIEW_DIR, "deliverables", "localsend-p0-fixes.patch"));
}

/* ---------------- Modified source files (repo working tree) ---------------- */

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

export function readSourceFile(relPath: string): string {
  return readTextFile(path.join(REPO_ROOT, relPath));
}

/* ---------------- Release manifest (runtime) ---------------- */

export interface ReleaseAsset {
  name: string;
  label: string;
  size?: number;
  url: string;
}

export interface ReleaseInfo {
  tag: string;
  name: string;
  html_url: string;
  published_at?: string;
  assets: ReleaseAsset[];
  pending?: boolean;
}

export function readReleaseInfo(): ReleaseInfo {
  try {
    return JSON.parse(fs.readFileSync(RELEASE_INFO_PATH, "utf-8")) as ReleaseInfo;
  } catch {
    // Manifest not written yet — deterministic preview of the planned release
    return {
      tag: RELEASE_TAG,
      name: "LocalSend 传输优化独立评审 + P0 修复 v1",
      html_url: `${REPO_URL}/releases/tag/${RELEASE_TAG}`,
      assets: [
        { name: "localsend-p0-fixes.patch", label: "P0 修复补丁（git apply 可直接应用，5 文件 +83/−6）", url: `${REPO_URL}/releases/download/${RELEASE_TAG}/localsend-p0-fixes.patch` },
        { name: "review-report-v2.md", label: "独立评审报告 v2.0 定稿（235 行）", url: `${REPO_URL}/releases/download/${RELEASE_TAG}/review-report-v2.md` },
        { name: "original-report.md", label: "被评审原报告（原件，未改动）", url: `${REPO_URL}/releases/download/${RELEASE_TAG}/original-report.md` },
        { name: "modified-source.zip", label: "5 个修改后源文件完整副本（含相对路径）", url: `${REPO_URL}/releases/download/${RELEASE_TAG}/modified-source.zip` },
        { name: "review-archive.zip", label: "完整评审存档（报告/草稿/补丁/站点源码/工作日志/交接档案）", url: `${REPO_URL}/releases/download/${RELEASE_TAG}/review-archive.zip` },
      ],
      pending: true,
    };
  }
}

/* ---------------- Unified diff parsing ---------------- */

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
