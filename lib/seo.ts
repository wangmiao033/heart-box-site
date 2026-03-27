import type { Metadata } from "next";
import { siteConfig } from "./site_config";

type PageMeta = {
  title: string;
  description: string;
  path?: string;
};

export function buildMetadata({ title, description, path = "" }: PageMeta): Metadata {
  const url = `${siteConfig.baseUrl}${path}`;
  const fullTitle =
    path === "" || path === "/"
      ? `${siteConfig.name} · ${siteConfig.tagline}`
      : `${title} · ${siteConfig.name}`;

  return {
    title: fullTitle,
    description,
    metadataBase: new URL(siteConfig.baseUrl),
    openGraph: {
      title: fullTitle,
      description,
      url,
      siteName: siteConfig.name,
      locale: "zh_CN",
      type: "website",
      images: [
        {
          url: "/og-cover.png",
          width: 1200,
          height: 630,
          alt: siteConfig.name,
        },
      ],
    },
    twitter: {
      card: "summary_large_image",
      title: fullTitle,
      description,
    },
    alternates: {
      canonical: url,
    },
  };
}
