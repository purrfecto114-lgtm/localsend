import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import "./globals.css";
import { Toaster } from "@/components/ui/toaster";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "LocalSend P0 · 源码储存站",
  description:
    "LocalSend 传输链路优化独立评审的源码储存站：fork main（基线 9529e915 + P0 修复 9a661080）源码浏览器、评审报告 v2、Release p0-review-v1 发布产物。",
  keywords: ["LocalSend", "源码存档", "独立评审", "P0 修复", "diff 浏览器"],
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="zh-CN" suppressHydrationWarning>
      <body
        className={`${geistSans.variable} ${geistMono.variable} antialiased bg-background text-foreground`}
      >
        {children}
        <Toaster />
      </body>
    </html>
  );
}
