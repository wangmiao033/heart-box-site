import type { ReactNode } from "react";
import Link from "next/link";
import { siteConfig } from "@/lib/site_config";
import { buildMetadata } from "@/lib/seo";

export const metadata = buildMetadata({
  title: "下载 / 打开",
  description:
    "获取心事匣：Web、iOS、Android 获取方式与版本说明。未上架渠道将标注为筹备中，请以实际公告为准。",
  path: "/download",
});

function LinkOrSoon({
  href,
  label,
  children,
}: {
  href: string;
  label: string;
  children: ReactNode;
}) {
  if (href) {
    return (
      <a href={href} className="btn btn--primary" rel="noopener noreferrer">
        {label}
      </a>
    );
  }
  return <span className="muted">{children}</span>;
}

export default function DownloadPage() {
  const { webUrl, iosUrl, androidUrl } = siteConfig.download;

  return (
    <>
      <div className="container page-hero">
        <h1 className="page-hero__title">下载 / 打开</h1>
        <p className="page-hero__lead muted">
          这里汇总当前可用的体验方式。商店链接未配置时，会显示为「筹备中」——避免误导；正式上架后只需在配置里填入地址即可。
        </p>
      </div>

      <section className="page-section">
        <div className="container prose">
          <h2>Web 版</h2>
          <p>
            <LinkOrSoon
              href={webUrl}
              label="在浏览器中打开"
            >
              若后续提供 Web 体验，将在此放置入口。当前未配置链接。
            </LinkOrSoon>
          </p>

          <h2>iOS</h2>
          <p>
            <LinkOrSoon href={iosUrl} label="前往 App Store">
              App Store 版本正在筹备中。上架后会在此更新链接；请关注应用内或本页说明。
            </LinkOrSoon>
          </p>

          <h2>Android</h2>
          <p>
            <LinkOrSoon href={androidUrl} label="前往应用商店 / 下载页">
              Android
              正式分发渠道确定后，会在此补充链接。测试包若存在，仅向受邀用户单独提供，不在此写死地址。
            </LinkOrSoon>
          </p>

          <h2>当前体验方式</h2>
          <p>
            若你已通过内测、TestFlight 或内部渠道安装，可直接继续使用；本页会在公开分发就绪后同步更新。
          </p>

          <h2>版本说明</h2>
          <p>
            具体版本号、更新日志以各平台商店或应用内「关于」为准。官网仅作入口与说明，不替代应用内信息。
          </p>

          <p className="note">
            需要协助请见
            <Link href="/support"> 用户支持</Link>
            ；隐私说明见
            <Link href="/privacy"> 隐私政策</Link>。
          </p>
        </div>
      </section>
    </>
  );
}
