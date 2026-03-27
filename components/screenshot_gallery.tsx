type Shot = {
  src: string;
  alt: string;
  caption: string;
};

type Props = {
  shots: Shot[];
  columns?: 2 | 3;
};

export function ScreenshotGallery({ shots, columns = 2 }: Props) {
  return (
    <ul
      className={`screenshot-gallery screenshot-gallery--cols-${columns}`}
    >
      {shots.map((s) => (
        <li key={s.src} className="screenshot-gallery__item">
          <figure className="screenshot-gallery__figure">
            <div className="screenshot-gallery__frame">
              <img src={s.src} alt={s.alt} width={390} height={844} />
            </div>
            <figcaption className="screenshot-gallery__caption muted">
              {s.caption}
            </figcaption>
          </figure>
        </li>
      ))}
    </ul>
  );
}
