"use client";

import { useCallback, useRef } from "react";
import { noteFilters, type NoteFilterId } from "@/lib/data/notes";
import { cn } from "@/lib/utils/cn";

type Props = {
  active: NoteFilterId;
  onChange: (id: NoteFilterId) => void;
};

export function NotesFilterBar({ active, onChange }: Props) {
  const btnRefs = useRef<Record<NoteFilterId, HTMLButtonElement | null>>(
    {} as Record<NoteFilterId, HTMLButtonElement | null>,
  );

  const setRef = useCallback((id: NoteFilterId, el: HTMLButtonElement | null) => {
    btnRefs.current[id] = el;
  }, []);

  const onKeyDown = useCallback(
    (e: React.KeyboardEvent) => {
      const idx = noteFilters.findIndex((f) => f.id === active);
      if (idx < 0) return;
      if (e.key === "ArrowRight" || e.key === "ArrowLeft") {
        e.preventDefault();
        const next =
          e.key === "ArrowRight"
            ? (idx + 1) % noteFilters.length
            : (idx - 1 + noteFilters.length) % noteFilters.length;
        const id = noteFilters[next]?.id;
        if (id) {
          onChange(id);
          btnRefs.current[id]?.focus();
        }
      }
      if (e.key === "Home") {
        e.preventDefault();
        const id = noteFilters[0]?.id;
        if (id) {
          onChange(id);
          btnRefs.current[id]?.focus();
        }
      }
      if (e.key === "End") {
        e.preventDefault();
        const id = noteFilters[noteFilters.length - 1]?.id;
        if (id) {
          onChange(id);
          btnRefs.current[id]?.focus();
        }
      }
    },
    [active, onChange],
  );

  return (
    <div className="-mx-4 overflow-x-auto overflow-y-hidden px-4 pb-1 scrollbar-hide md:mx-0 md:overflow-visible md:px-0 md:pb-0">
      <div
        className="flex w-max flex-nowrap gap-2 md:w-full md:flex-wrap md:justify-start md:gap-2.5"
        role="tablist"
        aria-label="筛选心事"
        onKeyDown={onKeyDown}
      >
        {noteFilters.map((f) => (
          <button
            key={f.id}
            ref={(el) => setRef(f.id, el)}
            type="button"
            role="tab"
            id={`note-filter-${f.id}`}
            aria-selected={active === f.id}
            tabIndex={active === f.id ? 0 : -1}
            onClick={() => onChange(f.id)}
            className={cn(
              "shrink-0 rounded-full border px-3.5 py-2 text-[13px] transition-[transform,background,border-color,box-shadow,color] duration-300 ease-soft sm:px-4 sm:text-sm",
              "focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent",
              active === f.id
                ? "border-accent-muted/55 bg-accent/20 text-ink shadow-[inset_0_1px_0_rgba(255,255,255,0.65)]"
                : "border-line/90 bg-page-elevated/85 text-sub hover:-translate-y-px hover:border-accent-muted/40 hover:bg-card hover:text-ink",
            )}
          >
            {f.label}
          </button>
        ))}
      </div>
    </div>
  );
}
