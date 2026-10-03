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
  title: "LocalSend 传输优化 · 评审与修复交付",
  description:
    "LocalSend 传输链路优化总报告的独立评审（79 处引用逐条核查、5 视角评审团反审查）与 P0 代码修复交付：评审报告、补丁与修改后源码持久化。",
  keywords: ["LocalSend", "评审报告", "源码核查", "BLE 发现", "组播", "代码修复"],
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
