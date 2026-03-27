import Link from "next/link";
import { siteConfig } from "@/lib/site_config";

export function HeroSection() {
  return (
    <section className="hero">
      <div className="container hero__inner">
        <div className="hero__copy">
          <p className="hero__eyebrow">心情日记</p>
          <h1 className="hero__title">{siteConfig.name}</h1>
          <p className="hero__lead">
            一个轻量、安静、低打扰的空间。写下此刻心情，慢慢整理思绪，在日历里轻轻回看那些被留住的日常。
          </p>
          <div className="hero__actions">
            <Link href="/download" className="btn btn--primary">
              立即体验
            </Link>
            <Link href="/features" className="btn btn--ghost">
              查看功能
            </Link>
          </div>
        </div>
        <div className="hero__visual" aria-hidden>
          <div className="hero__orb hero__orb--1" />
          <div className="hero__orb hero__orb--2" />
        </div>
      </div>
    </section>
  );
}
