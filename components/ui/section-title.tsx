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
        <p className="mb-1.5 text-[11px] font-medium uppercase tracking-[0.18em] text-sub md:mb-2 md:text-xs">
          {eyebrow}
        </p>
      ) : null}
      <h2 className="text-xl font-semibold leading-snug tracking-tight text-ink sm:text-[1.35rem] md:text-[1.55rem] lg:text-[1.65rem]">
        {title}
      </h2>
      {subtitle ? (
        <p
          className={cn(
            "mt-3 text-[14px] leading-relaxed text-sub sm:text-[15px] md:mt-3.5",
            align === "center" &&
              "mx-auto max-w-[min(100%,36ch)] sm:max-w-md md:max-w-lg",
            align === "left" && "max-w-prose",
          )}
        >
          {subtitle}
        </p>
      ) : null}
    </div>
  );
}
