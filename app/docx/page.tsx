import fs from 'fs';
import path from 'path';
import Link from 'next/link';

export default function DocsList() {
  const contentDirectory = path.join(process.cwd(), 'content');
  const filenames = fs.readdirSync(contentDirectory);
  const markdownFiles = filenames.filter(file => file.endsWith('.md'));
  
  return (
    <div className="min-h-screen bg-zinc-50 dark:bg-black">
      <div className="max-w-4xl mx-auto px-4 py-12">
        <h1 className="text-4xl font-bold mb-8 text-zinc-900 dark:text-zinc-50">
          文档列表
        </h1>
        <p className="max-w-xs text-lg leading-7 text-gray-500 dark:text-gray-400">
          目前文档暂无排序和筛选以及分类功能，仅展示所有文档。
        </p>
        <div className="grid gap-4">
          {markdownFiles.map((filename) => {
            const slug = filename.replace(/\.md$/, '');
            return (
              <Link
                key={filename}
                href={`/docx/${slug}`}
                className="block bg-white dark:bg-zinc-900 rounded-lg shadow-md p-6 hover:shadow-lg transition-shadow"
              >
                <h2 className="text-xl font-semibold text-zinc-900 dark:text-zinc-50">
                  {slug}
                </h2>
                <p className="text-zinc-600 dark:text-zinc-400 mt-2">
                  点击查看文档
                </p>
              </Link>
            );
          })}
        </div>
      </div>
    </div>
  );
}