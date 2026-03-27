"use client";

import { AnimatePresence, motion, useReducedMotion } from "framer-motion";
import { X } from "lucide-react";
import type { ReactNode } from "react";
import { useEffect } from "react";
import { cn } from "@/lib/utils/cn";

type Props = {
  open: boolean;
  onClose: () => void;
  title?: string;
  children: ReactNode;
  className?: string;
};

export function Modal({ open, onClose, title, children, className }: Props) {
  const reduceMotion = useReducedMotion();

  useEffect(() => {
    if (!open) return;
    const onKey = (e: KeyboardEvent) => {
      if (e.key === "Escape") onClose();
    };
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [open, onClose]);

  useEffect(() => {
    if (!open) return;
    const prev = document.body.style.overflow;
    document.body.style.overflow = "hidden";
    return () => {
      document.body.style.overflow = prev;
    };
  }, [open]);

  const t = reduceMotion
    ? { duration: 0.15 }
    : { duration: 0.38, ease: [0.25, 0.46, 0.45, 0.94] as const };

  return (
    <AnimatePresence>
      {open ? (
        <motion.div
          className="fixed inset-0 z-[100] flex items-center justify-center p-5"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          transition={{ duration: reduceMotion ? 0.12 : 0.22 }}
        >
          <button
            type="button"
            className="absolute inset-0 bg-ink/20 backdrop-blur-[3px] transition-opacity"
            aria-label="关闭对话框"
            onClick={onClose}
          />
          <motion.div
            role="dialog"
            aria-modal="true"
            aria-labelledby={title ? "modal-title" : undefined}
            className={cn(
              "relative z-10 w-full max-w-md overflow-hidden rounded-card border border-line/90 bg-card shadow-paper-hover",
              "before:pointer-events-none before:absolute before:inset-0 before:rounded-card before:bg-gradient-to-b before:from-white/40 before:to-transparent before:opacity-90",
              className,
            )}
            initial={
              reduceMotion
                ? { opacity: 0 }
                : { opacity: 0, y: 14, scale: 0.985 }
            }
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={
              reduceMotion
                ? { opacity: 0 }
                : { opacity: 0, y: 10, scale: 0.99 }
            }
            transition={t}
          >
            <div className="relative p-8 pt-9">
              <button
                type="button"
                onClick={onClose}
                className="absolute right-3 top-3 rounded-control p-2 text-sub transition-colors hover:bg-page-elevated hover:text-ink focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent"
                aria-label="关闭"
              >
                <X className="h-5 w-5" strokeWidth={1.5} />
              </button>
              {title ? (
                <h3
                  id="modal-title"
                  className="pr-12 text-lg font-semibold tracking-tight text-ink"
                >
                  {title}
                </h3>
              ) : null}
              <div
                className={cn(
                  "relative",
                  title ? "mt-6 border-t border-line/50 pt-6" : "pt-1",
                )}
              >
                {children}
              </div>
            </div>
          </motion.div>
        </motion.div>
      ) : null}
    </AnimatePresence>
  );
}
