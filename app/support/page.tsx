import { FaqSection } from "@/components/faq_section";
import { buildMetadata } from "@/lib/seo";
import { siteConfig } from "@/lib/site_config";
import Link from "next/link";

export const metadata = buildMetadata({
  title: "用户支持",
  description:
    "心事匣用户支持：常见问题、账号与数据、反馈渠道与联系邮箱。",
  path: "/support",
});

const faqItems = [
  {
    q: "心事匣是做什么的？",
    a: "一款偏轻量的心情与日记应用，强调本地优先、低打扰，帮助你记录与回看，而不是社交分享。",
  },
  {
    q: "数据存在哪里？",
    a: "默认以设备本地为主。若你使用账号或云同步（以应用内是否提供为准），部分数据会经加密同步至服务器，详见隐私政策。",
  },
  {
    q: "草稿会丢吗？",
    a: "应用会在编辑过程中尽量自动保存草稿，降低意外退出的损失。仍建议在网络与电量稳定时完成重要内容的确认。",
  },
  {
    q: "如何反馈问题或建议？",
    a: `请发送邮件至 ${siteConfig.contactEmail}，附上设备型号、系统版本、应用版本与复现步骤，便于我们排查。`,
  },
  {
    q: "如何找回账号？",
    a: "若已上线账号体系，请使用应用内「忘记密码」或绑定手机/邮箱找回。若当前版本未开放账号，则无需找回；后续开放时会补充本说明。",
  },
  {
    q: "会读取我的通讯录或相册吗？",
    a: "仅在功能需要且你明确授权时访问（例如选择图片作为附件）。可在系统设置中随时关闭相关权限。",
  },
];

export default function SupportPage() {
  return (
    <>
      <div className="container page-hero">
        <h1 className="page-hero__title">用户支持</h1>
        <p className="page-hero__lead muted">
          下面是一些常见疑问。没找到答案时，欢迎发邮件联系我们——回复时间视工作量而定，请尽量写清环境与复现方式。
        </p>
      </div>

      <section className="page-section">
        <div className="container">
          <h2 className="section-title__heading" style={{ marginBottom: "0.5rem" }}>
            常见问题
          </h2>
          <FaqSection items={faqItems} />
        </div>
      </section>

      <section className="page-section">
        <div className="container prose">
          <h2>联系邮箱</h2>
          <p>
            <a href={`mailto:${siteConfig.contactEmail}`}>{siteConfig.contactEmail}</a>
          </p>

          <h2>隐私与数据</h2>
          <p>
            关于收集范围、存储与安全，请阅读
            <Link href="/privacy">《隐私政策》</Link>
            。若应用内说明与本站不一致，以应用内最新版本为准。
          </p>

          <h2>后续补充</h2>
          <p>
            账号、云同步、重置密码等流程会随产品上线逐步补充到本页；当前文案为通用说明，不代表现已开放全部能力。
          </p>
        </div>
      </section>
    </>
  );
}
