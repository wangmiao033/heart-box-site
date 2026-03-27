type Props = {
  eyebrow?: string;
  title: string;
  subtitle?: string;
  align?: "left" | "center";
};

export function SectionTitle({
  eyebrow,
  title,
  subtitle,
  align = "center",
}: Props) {
  return (
    <header
      className={`section-title section-title--${align}`}
      style={{ textAlign: align }}
    >
      {eyebrow ? <p className="section-title__eyebrow">{eyebrow}</p> : null}
      <h2 className="section-title__heading">{title}</h2>
      {subtitle ? <p className="section-title__sub muted">{subtitle}</p> : null}
    </header>
  );
}
