"use client";

import { cn } from "@/lib/utils/cn";
import type { TextareaHTMLAttributes } from "react";
import { forwardRef } from "react";

type Props = TextareaHTMLAttributes<HTMLTextAreaElement>;

export const NotebookTextarea = forwardRef<HTMLTextAreaElement, Props>(
  function NotebookTextarea({ className, ...props }, ref) {
    return (
      <div
        className={cn(
          "relative overflow-hidden rounded-control border border-line/90 bg-[#FDFBF8]",
          "shadow-[inset_0_1px_2px_rgba(62,58,55,0.04)]",
          "transition-[border-color,box-shadow] duration-300 ease-soft",
          "focus-within:border-accent-muted/70 focus-within:shadow-[0_0_0_3px_rgba(255,244,214,0.35),inset_0_1px_2px_rgba(62,58,55,0.04)]",
        )}
      >
        <div
          className="pointer-events-none absolute inset-0 bg-paper-lines opacity-70"
          aria-hidden
        />
        <div
          className="pointer-events-none absolute inset-0 texture-noise opacity-40 mix-blend-multiply"
          aria-hidden
        />
        <textarea
          ref={ref}
          className={cn(
            "relative z-[1] min-h-[132px] w-full resize-y bg-transparent px-4 py-3.5 text-[15px] leading-[1.75] text-ink",
            "placeholder:text-sub/55 placeholder:transition-opacity",
            "outline-none",
            className,
          )}
          {...props}
        />
      </div>
    );
  },
);
