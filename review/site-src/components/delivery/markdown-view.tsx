"use client";

import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";

interface MarkdownViewProps {
  content: string;
}

/** Renders a markdown document with report-grade typography. */
export function MarkdownView({ content }: MarkdownViewProps) {
  return (
    <div className="report-prose max-w-none text-[15px] leading-relaxed text-zinc-800 dark:text-zinc-200">
      <ReactMarkdown
        remarkPlugins={[remarkGfm]}
        components={{
          h1: ({ children }) => (
            <h1 className="mb-4 mt-8 border-b-2 border-emerald-600/70 pb-2 text-2xl font-bold tracking-tight text-zinc-900 first:mt-0 dark:text-zinc-50">
              {children}
            </h1>
          ),
          h2: ({ children }) => (
            <h2 className="mb-3 mt-8 border-b border-zinc-200 pb-1.5 text-xl font-bold text-zinc-900 dark:border-zinc-700 dark:text-zinc-100">
              {children}
            </h2>
          ),
          h3: ({ children }) => (
            <h3 className="mb-2 mt-6 text-lg font-semibold text-zinc-800 dark:text-zinc-100">{children}</h3>
          ),
          h4: ({ children }) => (
            <h4 className="mb-2 mt-4 text-base font-semibold text-zinc-700 dark:text-zinc-200">{children}</h4>
          ),
          p: ({ children }) => <p className="my-3 text-justify">{children}</p>,
          strong: ({ children }) => <strong className="font-semibold text-zinc-900 dark:text-zinc-50">{children}</strong>,
          em: ({ children }) => <em className="not-italic underline decoration-emerald-500/60 decoration-2 underline-offset-2">{children}</em>,
          ul: ({ children }) => <ul className="my-3 list-disc space-y-1.5 pl-6">{children}</ul>,
          ol: ({ children }) => <ol className="my-3 list-decimal space-y-1.5 pl-6">{children}</ol>,
          li: ({ children }) => <li className="pl-1 leading-relaxed">{children}</li>,
          blockquote: ({ children }) => (
            <blockquote className="my-4 rounded-r-md border-l-4 border-emerald-600/70 bg-emerald-50/60 px-4 py-2 text-zinc-700 dark:bg-emerald-950/30 dark:text-zinc-300">
              {children}
            </blockquote>
          ),
          hr: () => <hr className="my-8 border-zinc-200 dark:border-zinc-700" />,
          a: ({ children, href }) => (
            <a href={href} className="text-emerald-700 underline underline-offset-2 dark:text-emerald-400">
              {children}
            </a>
          ),
          table: ({ children }) => (
            <div className="my-4 overflow-x-auto rounded-lg border border-zinc-200 dark:border-zinc-700">
              <table className="w-full border-collapse text-[13px]">{children}</table>
            </div>
          ),
          thead: ({ children }) => <thead className="bg-zinc-100 dark:bg-zinc-800">{children}</thead>,
          th: ({ children }) => (
            <th className="border-b border-zinc-200 px-3 py-2 text-left font-semibold text-zinc-700 dark:border-zinc-600 dark:text-zinc-200">
              {children}
            </th>
          ),
          td: ({ children }) => (
            <td className="border-b border-zinc-100 px-3 py-2 align-top text-zinc-700 dark:border-zinc-800 dark:text-zinc-300">
              {children}
            </td>
          ),
          code: ({ className, children }) => {
            const isBlock = /language-/.test(className ?? "");
            if (isBlock) {
              return (
                <code className={`${className} block overflow-x-auto p-4 font-mono text-[12.5px] leading-relaxed`}>
                  {children}
                </code>
              );
            }
            return (
              <code className="rounded bg-zinc-100 px-1.5 py-0.5 font-mono text-[12.5px] text-emerald-800 dark:bg-zinc-800 dark:text-emerald-300">
                {children}
              </code>
            );
          },
          pre: ({ children }) => (
            <pre className="my-4 overflow-x-auto rounded-lg border border-zinc-800 bg-zinc-900 text-zinc-100 dark:border-zinc-700">
              {children}
            </pre>
          ),
        }}
      >
        {content}
      </ReactMarkdown>
    </div>
  );
}
