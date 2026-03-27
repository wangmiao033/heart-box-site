import {
  LegalDocumentPage,
  legalStyles as ls,
} from "@/components/layout/legal-document-page";
import { buildMetadata } from "@/lib/seo";
import { cn } from "@/lib/utils/cn";

export const metadata = buildMetadata({
  title: "隐私政策",
  description:
    "心事匣隐私政策：说明我们收集的信息、使用方式、存储与安全、共享说明、权限与您的权利及联系方式。",
  path: "/privacy",
});

export default function PrivacyPage() {
  return (
    <LegalDocumentPage
      title="隐私政策"
      meta={[
        { label: "更新日期", value: "2026年03月27日" },
        { label: "生效日期", value: "2026年03月27日" },
      ]}
    >
      <p className={cn(ls.p, "mt-0")}>
        欢迎使用「心事匣」。我们非常重视您的个人信息和隐私保护。本隐私政策将帮助您了解我们如何收集、使用、存储和保护您的信息。
      </p>

      <hr className={ls.hr} aria-hidden />

      <h2 className={ls.h2}>一、我们收集的信息</h2>
      <p className={ls.p}>
        在您使用本产品过程中，我们可能收集以下信息：
      </p>

      <h3 className={ls.h3}>1. 您主动提供的信息</h3>
      <ul className={ls.ul}>
        <li>您输入的文本内容（如记录的心事）</li>
        <li>反馈信息（如通过客服提交的问题）</li>
      </ul>

      <h3 className={ls.h3}>2. 设备与日志信息</h3>
      <ul className={ls.ul}>
        <li>设备型号</li>
        <li>操作系统版本</li>
        <li>应用版本</li>
        <li>网络类型</li>
        <li>崩溃日志（用于问题排查）</li>
      </ul>

      <h3 className={ls.h3}>3. 存储权限（如涉及）</h3>
      <ul className={ls.ul}>
        <li>用于保存您输入的内容或导出数据</li>
      </ul>

      <h2 className={ls.h2}>二、信息的使用方式</h2>
      <p className={ls.p}>我们收集信息仅用于以下目的：</p>
      <ul className={ls.ul}>
        <li>提供和维护产品核心功能</li>
        <li>改善用户体验</li>
        <li>处理用户反馈</li>
        <li>修复程序错误和优化性能</li>
      </ul>

      <h2 className={ls.h2}>三、信息存储与安全</h2>
      <ul className={ls.ul}>
        <li>您的内容优先存储在本地设备（如适用）</li>
        <li>我们采取合理安全措施防止信息泄露、损坏或丢失</li>
        <li>在必要情况下，我们会使用加密技术保护数据</li>
      </ul>

      <h2 className={ls.h2}>四、信息共享说明</h2>
      <p className={ls.p}>
        我们不会向任何第三方出售您的个人信息。
        <br />
        仅在以下情况可能共享：
      </p>
      <ul className={ls.ul}>
        <li>法律法规要求</li>
        <li>为保障用户或公众安全</li>
        <li>为提供基础服务所必须（如云服务提供商）</li>
      </ul>

      <h2 className={ls.h2}>五、权限说明</h2>
      <p className={ls.p}>本应用可能申请以下权限：</p>
      <ul className={ls.ul}>
        <li>存储权限：用于保存您的记录内容</li>
        <li>网络权限：用于基础功能及数据同步（如有）</li>
      </ul>
      <p className={ls.p}>所有权限均仅在必要范围内使用。</p>

      <h2 className={ls.h2}>六、您的权利</h2>
      <p className={ls.p}>您有权：</p>
      <ul className={ls.ul}>
        <li>查看和管理您的数据</li>
        <li>删除相关记录内容</li>
        <li>停止使用本产品</li>
      </ul>

      <h2 className={ls.h2}>七、未成年人保护</h2>
      <p className={ls.p}>
        本产品不面向未满14周岁的未成年人。
        <br />
        如您为未成年人，请在监护人指导下使用。
      </p>

      <h2 className={ls.h2}>八、隐私政策更新</h2>
      <p className={ls.p}>
        我们可能会适时更新本隐私政策。
        <br />
        更新后将在页面公布，请您定期查看。
      </p>

      <h2 className={ls.h2}>九、联系我们</h2>
      <p className={ls.p}>如您对本隐私政策有任何疑问，请联系：</p>
      <p className={ls.p}>
        邮箱：
        <a className={ls.link} href="mailto:pingce@dxyx6888.com">
          pingce@dxyx6888.com
        </a>
      </p>
    </LegalDocumentPage>
  );
}
