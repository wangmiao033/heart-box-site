import { cn } from "@/lib/utils/cn";
import type { ReactNode } from "react";

type Props = {
  children: ReactNode;
  className?: string;
  hover?: boolean;
  padding?: "sm" | "md" | "lg";
};

const padMap = {
  sm: "p-4 md:p-5",
  md: "p-5 md:p-6 lg:p-7",
  lg: "p-5 md:p-7 lg:p-9",
};

export function PaperCard({
  children,
  className,
  hover = false,
  padding = "md",
}: Props) {
  return (
    <div
      className={cn(
        "rounded-card-md border border-line/95 bg-card shadow-paper",
        "transition-[transform,box-shadow,border-color] duration-500 ease-soft",
        hover &&
          "hover:-translate-y-0.5 hover:border-line hover:shadow-paper-hover",
        padMap[padding],
        className,
      )}
    >
      {children}
    </div>
  );
}
