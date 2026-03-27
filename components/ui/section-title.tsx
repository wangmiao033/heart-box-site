import { cn } from "@/lib/utils/cn";

type Props = {
  eyebrow?: string;
  title: string;
  subtitle?: string;
  align?: "left" | "center";
  className?: string;
};

export function SectionTitle({
  eyebrow,
  title,
  subtitle,
  align = "center",
  className,
}: Props) {
  return (
    <div
      className={cn(
        align === "center" ? "mx-auto text-center" : "text-left",
        className,
      )}
    >
      {eyebrow ? (
        <p className="mb-2 text-xs font-medium uppercase tracking-[0.18em] text-sub">
          {eyebrow}
        </p>
      ) : null}
      <h2 className="text-2xl font-semibold leading-snug text-ink md:text-[1.65rem]">
        {title}
      </h2>
      {subtitle ? (
        <p
          className={cn(
            "mt-4 text-[15px] leading-relaxed text-sub",
            align === "center" && "mx-auto max-w-lg",
          )}
        >
          {subtitle}
        </p>
      ) : null}
    </div>
  );
}
