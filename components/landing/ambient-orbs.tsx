"use client";

export function AmbientOrbs() {
  return (
    <div
      className="pointer-events-none fixed inset-0 -z-10 overflow-hidden"
      aria-hidden
    >
      <div
        className="absolute -left-32 top-24 h-[min(420px,70vw)] w-[min(420px,70vw)] rounded-full bg-brand opacity-40 blur-[120px] animate-orb-a"
      />
      <div
        className="absolute right-[-10%] top-1/3 h-[min(380px,65vw)] w-[min(380px,65vw)] rounded-full bg-blush opacity-40 blur-[120px] animate-orb-b"
      />
      <div
        className="absolute bottom-[5%] left-1/3 h-[min(400px,68vw)] w-[min(400px,68vw)] rounded-full bg-mint opacity-40 blur-[120px] animate-orb-c"
      />
    </div>
  );
}
