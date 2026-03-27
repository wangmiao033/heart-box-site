"use client";

import { useEffect, useLayoutEffect } from "react";
import {
  motion,
  useMotionTemplate,
  useMotionValue,
  useReducedMotion,
  useSpring,
} from "framer-motion";

/** 全站柔和暖光跟随鼠标，pointer-events: none */
export function LampCursorGlow() {
  const reduceMotion = useReducedMotion();
  const mx = useMotionValue(0);
  const my = useMotionValue(0);
  const sx = useSpring(mx, { stiffness: 220, damping: 36, mass: 0.32 });
  const sy = useSpring(my, { stiffness: 220, damping: 36, mass: 0.32 });

  useLayoutEffect(() => {
    const c = () => {
      mx.set(window.innerWidth / 2);
      my.set(window.innerHeight / 2);
    };
    c();
    window.addEventListener("resize", c);
    return () => window.removeEventListener("resize", c);
  }, [mx, my]);

  useEffect(() => {
    const onMove = (e: MouseEvent) => {
      mx.set(e.clientX);
      my.set(e.clientY);
    };
    window.addEventListener("mousemove", onMove, { passive: true });
    return () => window.removeEventListener("mousemove", onMove);
  }, [mx, my]);

  const background = useMotionTemplate`radial-gradient(
    circle 240px at ${sx}px ${sy}px,
    rgba(255, 244, 214, 0.32) 0%,
    rgba(255, 244, 214, 0.12) 42%,
    rgba(62, 58, 55, 0.06) 72%,
    rgba(40, 36, 33, 0.12) 100%
  )`;

  if (reduceMotion) {
    return (
      <div
        className="pointer-events-none fixed inset-0 z-[5] bg-gradient-to-b from-transparent to-[rgba(62,58,55,0.04)]"
        aria-hidden
      />
    );
  }

  return (
    <motion.div
      className="pointer-events-none fixed inset-0 z-[5]"
      style={{ background }}
      aria-hidden
    />
  );
}
