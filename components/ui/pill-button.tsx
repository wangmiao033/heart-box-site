import Link from "next/link";
import { cn } from "@/lib/utils/cn";
import type { ReactNode } from "react";

type Base = {
  children: ReactNode;
  className?: string;
  variant?: "primary" | "ghost";
};

type LinkProps = Base & { href: string; external?: boolean };

const base =
  "inline-flex min-h-[48px] items-center justify-center rounded-full px-8 py-3 text-[15px] font-medium tracking-tight transition-[transform,box-shadow,background,border-color] duration-300 ease-soft focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent";

export function PillButton(props: LinkProps) {
  const { href, children, className, variant = "primary", external } = props;
  const styles = cn(
    base,
    variant === "primary" &&
      "bg-accent text-ink shadow-paper hover:-translate-y-0.5 hover:bg-[#E5B59A] hover:shadow-paper-hover active:translate-y-0",
    variant === "ghost" &&
      "border border-line/90 bg-page-elevated/90 text-ink hover:-translate-y-0.5 hover:border-accent-muted/50 hover:bg-card active:translate-y-0",
    className,
  );
  if (external) {
    return (
      <a href={href} className={styles} rel="noopener noreferrer" target="_blank">
        {children}
      </a>
    );
  }
  return (
    <Link href={href} className={styles}>
      {children}
    </Link>
  );
}
