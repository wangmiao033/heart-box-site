import type { ReactNode } from "react";
import { Container } from "@/components/layout/container";
import { PaperCard } from "@/components/ui/paper-card";
import { cn } from "@/lib/utils/cn";

export const legalStyles = {
  h2: "mt-8 border-b border-line/75 pb-2 text-[1.05rem] font-semibold tracking-tight text-ink sm:mt-9 sm:text-lg",
  h3: "mt-5 text-[0.95rem] font-semibold text-ink sm:text-base",
  p: "mt-3 text-[14px] leading-[1.75] text-sub sm:text-[15px] sm:leading-[1.78]",
  ul: "mt-3 list-disc space-y-1.5 pl-[1.15rem] text-[14px] leading-relaxed text-sub marker:text-accent-muted sm:text-[15px]",
  hr: "my-7 border-0 border-t border-line/80 sm:my-8",
  link: "rounded text-ink underline decoration-line/70 underline-offset-[3px] transition-colors hover:decoration-accent hover:text-ink",
} as const;

type MetaLine = { label: string; value: string };

type Props = {
  title: string;
  meta?: MetaLine[];
  children: ReactNode;
  className?: string;
};

export function LegalDocumentPage({ title, meta, children, className }: Props) {
  return (
    <section
      className={cn(
        "py-10 pb-14 md:py-12 md:pb-16 lg:py-14 lg:pb-20",
        className,
      )}
    >
      <Container>
        <div className="mx-auto w-full max-w-[40rem]">
          <PaperCard
            padding="lg"
            className="relative overflow-hidden border-line/90 shadow-paper"
          >
            <div
              className="pointer-events-none absolute inset-0 bg-paper-lines opacity-[0.22]"
              aria-hidden
            />
            <div
              className="pointer-events-none absolute inset-0 texture-noise opacity-15 mix-blend-multiply"
              aria-hidden
            />
            <header className="relative border-b border-line/55 pb-5 sm:pb-6">
              <h1 className="text-[clamp(1.35rem,4vw,1.85rem)] font-semibold leading-[1.2] tracking-tight text-ink">
                {title}
              </h1>
              {meta?.length ? (
                <div className="mt-3 space-y-0.5 text-[13px] leading-relaxed text-sub sm:mt-4 sm:text-sm">
                  {meta.map((m) => (
                    <p key={m.label}>
                      <span className="text-sub/90">{m.label}：</span>
                      {m.value}
                    </p>
                  ))}
                </div>
              ) : null}
            </header>
            <div className="relative pt-6 sm:pt-7 md:pt-8">{children}</div>
          </PaperCard>
        </div>
      </Container>
    </section>
  );
}
