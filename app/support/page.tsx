import Link from "next/link";
import {
  LegalDocumentPage,
  legalStyles as ls,
} from "@/components/layout/legal-document-page";
import { buildMetadata } from "@/lib/seo";
import { cn } from "@/lib/utils/cn";

export const metadata = buildMetadata({
  title: "用户支持",
  description:
    "心事匣用户支持：常见问题、问题反馈方式、响应时间及建议与合作联系邮箱。",
  path: "/support",
});

export default function SupportPage() {
  return (
    <LegalDocumentPage title="用户支持">
      <p className={cn(ls.p, "mt-0")}>欢迎使用「心事匣」。</p>
      <p className={ls.p}>
        如果您在使用过程中遇到问题，或有任何建议与反馈，可以通过以下方式联系我们。
      </p>

      <hr className={ls.hr} aria-hidden />

      <h2 className={ls.h2}>一、常见问题</h2>

      <h3 className={ls.h3}>1. 无法正常使用应用怎么办？</h3>
      <p className={ls.p}>请尝试以下操作：</p>
      <ul className={ls.ul}>
        <li>重启应用</li>
        <li>检查网络连接</li>
        <li>更新到最新版本</li>
      </ul>

      <hr className={ls.hr} aria-hidden />

      <h3 className={ls.h3}>2. 数据会丢失吗？</h3>
      <p className={ls.p}>
        我们会尽力保障数据安全。
        <br />
        如您使用本地存储，请注意设备数据备份。
      </p>

      <hr className={ls.hr} aria-hidden />

      <h3 className={ls.h3}>3. 是否支持多设备同步？</h3>
      <p className={ls.p}>
        该功能将根据版本逐步开放，请以应用内说明为准。
      </p>

      <hr className={ls.hr} aria-hidden />

      <h3 className={ls.h3}>4. 是否收费？</h3>
      <p className={ls.p}>
        当前版本为基础功能体验，后续版本将根据功能规划调整。
      </p>

      <h2 className={ls.h2}>二、问题反馈</h2>
      <p className={ls.p}>
        如果您遇到问题，请通过以下方式联系我们：
      </p>
      <p className={ls.p}>
        邮箱：
        <a className={ls.link} href="mailto:pingce@dxyx6888.com">
          pingce@dxyx6888.com
        </a>
      </p>
      <p className={ls.p}>请在邮件中尽量提供：</p>
      <ul className={ls.ul}>
        <li>问题描述</li>
        <li>设备型号</li>
        <li>系统版本</li>
        <li>应用版本</li>
      </ul>

      <h2 className={ls.h2}>三、响应时间</h2>
      <p className={ls.p}>
        我们通常会在 1-3 个工作日内回复您的邮件。
      </p>

      <h2 className={ls.h2}>四、建议与合作</h2>
      <p className={ls.p}>
        如果您有产品建议或合作意向，也欢迎通过邮箱联系我们。
      </p>
      <p className={ls.p}>
        关于个人信息处理与数据安全，请参阅
        <Link href="/privacy" className={cn(ls.link, "mx-0.5")}>
          《隐私政策》
        </Link>
        。
      </p>
      <p className={ls.p}>感谢您的使用与支持。</p>
    </LegalDocumentPage>
  );
}
