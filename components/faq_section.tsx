type Qa = { q: string; a: string };

type Props = {
  items: Qa[];
};

export function FaqSection({ items }: Props) {
  return (
    <dl className="faq">
      {items.map((item) => (
        <div key={item.q} className="faq__item">
          <dt className="faq__q">{item.q}</dt>
          <dd className="faq__a muted">{item.a}</dd>
        </div>
      ))}
    </dl>
  );
}
