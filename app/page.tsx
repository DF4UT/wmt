import Link from "next/link";

export default function Home() {
  return (
    <div className="flex flex-col flex-1 items-center justify-center bg-zinc-50 font-sans dark:bg-black">
      <main className="flex flex-1 w-full max-w-3xl flex-col items-center justify-between py-32 px-16 bg-white dark:bg-black sm:items-start">
        <div className="flex flex-col items-center gap-6 text-center sm:items-start sm:text-left">
          <h1 className="max-w-xs text-3xl font-semibold leading-10 tracking-tight text-black dark:text-zinc-50">
            Next.js 在线抄你码
          </h1>
          <p className="max-w-xs text-lg leading-7 text-gray-500 dark:text-gray-400">
            临时存放markdown文档
          </p>
          <p className="max-w-xs text-lg leading-7 text-gray-500 dark:text-gray-400">
            仅2026.7前正常服务，逾期将停止服务
          </p>
          <p className="max-w-xs text-lg leading-7 text-gray-500 dark:text-gray-400">
            本站文档仅供参考，均在测试通过后上传，若存在错误请随机应变，方便时可联系开发者
          </p>
        </div>
        <div className="flex flex-col gap-4 text-base font-medium sm:flex-row">
          <Link
            className="flex h-12 w-full items-center justify-center gap-2 rounded-full bg-foreground px-5 text-background transition-colors hover:bg-[#383838] dark:hover:bg-[#ccc] md:w-[158px]"
            href="/docx"
          >
            查看文档
          </Link>
        </div>
      </main>
    </div>
  );
}