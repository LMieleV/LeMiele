import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Kloer — Compliance, kloer a simpel",
  description: "AI-native continuous compliance for the Luxembourg fund industry",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>
        <header className="topbar">
          <span className="logo">kloer</span>
          <span className="tagline">Compliance, kloer a simpel.</span>
        </header>
        <main>{children}</main>
      </body>
    </html>
  );
}
