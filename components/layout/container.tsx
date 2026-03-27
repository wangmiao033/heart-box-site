import { cn } from "@/lib/utils/cn";
import type { ReactNode } from "react";

type Props = {
  children: ReactNode;
  className?: string;
};

export function Container({ children, className }: Props) {
  return (
    <div
      className={cn(
        "mx-auto w-full max-w-6xl px-4 sm:px-5 md:px-9 lg:px-10",
        className,
      )}
    >
      {children}
    </div>
  );
}
