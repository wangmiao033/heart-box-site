"use client";

import { motion, useReducedMotion } from "framer-motion";

/** 极淡漂浮光斑，超慢循环 */
export function SoftBlobBackground() {
  const reduceMotion = useReducedMotion();

  if (reduceMotion) {
    return (
      <div
        className="pointer-events-none fixed inset-0 z-[1] overflow-hidden"
        aria-hidden
      >
        <div className="absolute inset-0 bg-page" />
      </div>
    );
  }

  return (
    <div
      className="pointer-events-none fixed inset-0 z-[1] overflow-hidden"
      aria-hidden
    >
      <div className="absolute inset-0 bg-page" />
      <motion.div
        className="absolute -left-[20%] top-[10%] h-[min(420px,55vw)] w-[min(420px,55vw)] rounded-full bg-accent/15 blur-[100px]"
        animate={{ x: [0, 24, 0], y: [0, 18, 0] }}
        transition={{ duration: 28, repeat: Infinity, ease: "easeInOut" }}
      />
      <motion.div
        className="absolute bottom-[5%] right-[-15%] h-[min(380px,50vw)] w-[min(380px,50vw)] rounded-full bg-accent-muted/20 blur-[100px]"
        animate={{ x: [0, -20, 0], y: [0, -14, 0] }}
        transition={{ duration: 32, repeat: Infinity, ease: "easeInOut" }}
      />
      <motion.div
        className="absolute left-[35%] top-[55%] h-[min(300px,40vw)] w-[min(300px,40vw)] rounded-full bg-[#DCE8F9]/25 blur-[90px]"
        animate={{ x: [0, 16, 0], y: [0, -22, 0] }}
        transition={{ duration: 36, repeat: Infinity, ease: "easeInOut" }}
      />
    </div>
  );
}
