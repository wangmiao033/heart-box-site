import { cn } from "@/lib/utils/cn";

type Props = {
  children: React.ReactNode;
  className?: string;
};

export function BadgePill({ children, className }: Props) {
  return (
    <span
      className={cn(
        "inline-flex rounded-full border border-line bg-page-elevated px-3 py-1 text-xs text-sub",
        className,
      )}
    >
      {children}
    </span>
  );
}
