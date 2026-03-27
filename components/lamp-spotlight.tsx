"use client";

import { useEffect, useLayoutEffect } from "react";
import {
  motion,
  useMotionTemplate,
  useMotionValue,
  useReducedMotion,
  useSpring,
} from "framer-motion";

/**
 * 台灯跟随鼠标：径向暖光 + 边缘略暗，pointer-events: none
 */
export function LampSpotlight() {
  const reduceMotion = useReducedMotion();
  const mx = useMotionValue(0);
  const my = useMotionValue(0);
  const sx = useSpring(mx, { stiffness: 200, damping: 32, mass: 0.35 });
  const sy = useSpring(my, { stiffness: 200, damping: 32, mass: 0.35 });

  useLayoutEffect(() => {
    const setCenter = () => {
      mx.set(window.innerWidth / 2);
      my.set(window.innerHeight / 2);
    };
    setCenter();
    window.addEventListener("resize", setCenter);
    return () => window.removeEventListener("resize", setCenter);
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
    circle 260px at ${sx}px ${sy}px,
    rgba(255, 230, 200, 0.36) 0%,
    rgba(255, 224, 190, 0.16) 38%,
    rgba(40, 32, 26, 0.12) 68%,
    rgba(12, 10, 8, 0.22) 100%
  )`;

  if (reduceMotion) {
    return (
      <div
        className="pointer-events-none fixed inset-0 z-[5] bg-gradient-to-b from-transparent via-transparent to-[rgba(18,14,12,0.06)]"
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
