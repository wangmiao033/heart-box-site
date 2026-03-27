import Link from "next/link";

type Props = {
  title?: string;
  body?: string;
  primaryHref?: string;
  primaryLabel?: string;
  secondaryHref?: string;
  secondaryLabel?: string;
};

export function CtaSection({
  title = "想试试吗？",
  body = "从下载页了解当前可用的体验方式。我们会保持克制更新，不打扰你的日常。",
  primaryHref = "/download",
  primaryLabel = "前往下载 / 打开",
  secondaryHref = "/support",
  secondaryLabel = "需要帮助",
}: Props) {
  return (
    <section className="cta-section">
      <div className="container cta-section__inner">
        <h2 className="cta-section__title">{title}</h2>
        <p className="cta-section__body muted">{body}</p>
        <div className="cta-section__actions">
          <Link href={primaryHref} className="btn btn--primary">
            {primaryLabel}
          </Link>
          <Link href={secondaryHref} className="btn btn--ghost">
            {secondaryLabel}
          </Link>
        </div>
      </div>
    </section>
  );
}
