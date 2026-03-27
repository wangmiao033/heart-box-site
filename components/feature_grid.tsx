type Item = {
  title: string;
  description: string;
  tone?: "mist" | "lavender" | "sage" | "blush";
};

type Props = {
  items: Item[];
  className?: string;
};

export function FeatureGrid({ items, className = "" }: Props) {
  return (
    <ul className={`feature-grid ${className}`.trim()}>
      {items.map((item) => (
        <li
          key={item.title}
          className={`feature-card feature-card--${item.tone ?? "mist"}`}
        >
          <h3 className="feature-card__title">{item.title}</h3>
          <p className="feature-card__desc muted">{item.description}</p>
        </li>
      ))}
    </ul>
  );
}
