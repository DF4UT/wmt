import fs from 'fs';
import path from 'path';
import MarkdownRenderer from '@/components/MarkdownRenderer';

interface DocsPageProps {
  params: Promise<{
    slug: string;
  }>;
}

export async function generateStaticParams() {
  const contentDirectory = path.join(process.cwd(), 'content');
  const filenames = fs.readdirSync(contentDirectory);
  
  return filenames.map((filename) => ({
    slug: filename.replace(/\.md$/, ''),
  }));
}

export default async function DocsPage({ params }: DocsPageProps) {
  const { slug } = await params;
  const contentDirectory = path.join(process.cwd(), 'content');
  const fullPath = path.join(contentDirectory, `${slug}.md`);
  
  const fileContents = fs.readFileSync(fullPath, 'utf8');
  
  return (
    <div className="min-h-screen bg-zinc-50 dark:bg-black">
      <div className="max-w-4xl mx-auto px-4 py-12">
        <div className="bg-white dark:bg-zinc-900 rounded-lg shadow-lg p-8">
          <MarkdownRenderer content={fileContents} />
        </div>
      </div>
    </div>
  );
}