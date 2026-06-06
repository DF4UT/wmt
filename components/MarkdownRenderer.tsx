'use client';

import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';
import rehypeHighlight from 'rehype-highlight';
import rehypeRaw from 'rehype-raw';
import { useState, ComponentPropsWithoutRef } from 'react';
import Image from 'next/image';
import 'highlight.js/styles/github-dark.css';

type CodeProps = ComponentPropsWithoutRef<'code'> & {
  inline?: boolean;
  children?: React.ReactNode;
};

type ImgProps = ComponentPropsWithoutRef<'img'>;

export default function MarkdownRenderer({ content }: { content: string }) {
  const [copiedCode, setCopiedCode] = useState<string | null>(null);

  const handleCopy = (code: string) => {
    navigator.clipboard.writeText(code);
    setCopiedCode(code);
    setTimeout(() => setCopiedCode(null), 2000);
  };

  return (
    <div className="prose prose-zinc dark:prose-invert max-w-none">
      <ReactMarkdown
        remarkPlugins={[remarkGfm]}
        rehypePlugins={[rehypeHighlight, rehypeRaw]}
        components={{
          code({ inline, className, children }: CodeProps) {
            const match = /language-(\w+)/.exec(className || '');
            const language = match ? match[1] : '';
            
            // 正确处理 children，可能是数组或对象
            const extractText = (node: React.ReactNode): string => {
              if (typeof node === 'string') return node;
              if (typeof node === 'number') return String(node);
              if (Array.isArray(node)) return node.map(extractText).join('');
              if (node && typeof node === 'object' && 'props' in node) {
                return extractText((node as any).props?.children);
              }
              return '';
            };
            
            const codeContent = extractText(children).replace(/\n$/, '');

            if (!inline && match) {
              return (
                <div className="relative group">
                  <div className="flex items-center justify-between bg-zinc-800 text-zinc-100 px-4 py-2 rounded-t-lg">
                    <span className="text-sm font-medium">{language}</span>
                    <button
                      onClick={() => handleCopy(codeContent)}
                      className="text-xs px-3 py-1 bg-zinc-700 hover:bg-zinc-600 rounded transition-colors"
                    >
                      {copiedCode === codeContent ? '已复制!' : '复制'}
                    </button>
                  </div>
                  <pre className="!mt-0 !rounded-t-none">
                    <code className={className}>
                      {children}
                    </code>
                  </pre>
                </div>
              );
            }

            return (
              <code className={className}>
                {children}
              </code>
            );
          },
          img({ src, alt, className }: ImgProps) {
            if (!src) return null;
            
            let imageSrc = '';
            
            // 处理不同格式的图片路径
            if (typeof src === 'string') {
              // 格式1: ![[filename.png]] - Obsidian 风格
              if (src.startsWith('![[')) {
                imageSrc = '/' + src.replace('![[', '').replace(']]', '');
              }
              // 格式2: file:///wmt/public/IMG/cnt.png - 绝对路径
              else if (src.startsWith('file:///')) {
                // 提取相对路径
                const match = src.match(/\/public\/(.+)$/);
                imageSrc = match ? '/' + match[1] : src;
              }
              // 格式3: 已经是相对路径
              else {
                imageSrc = src.startsWith('/') ? src : '/' + src;
              }
            }
            
            if (!imageSrc) {
              return null;
            }
            
            return (
              <div className="relative w-full h-auto my-6">
                <Image 
                  src={imageSrc} 
                  alt={alt || ''} 
                  width={800}
                  height={400}
                  className={`rounded-lg shadow-lg ${className || ''}`}
                />
              </div>
            );
          },
          // 自定义链接组件 - 文件下载
          a({ href, children, ...props }: ComponentPropsWithoutRef<'a'>) {
            if (!href) {
              return <a {...props}>{children}</a>;
            }
            
            // 检测是否为文件链接
            const isFileLink = (
              href.includes('/FILE/') || 
              href.includes('/public/FILE/') ||
              href.includes('/file/') ||
              href.startsWith('![[FILE/') ||
              href.includes('.sh') ||
              href.includes('.pdf') ||
              href.includes('.zip') ||
              href.includes('.txt')
            );
            
            // 处理文件路径
            let filePath = href;
            if (typeof href === 'string') {
              if (href.startsWith('![[FILE/')) {
                filePath = '/' + href.replace('![[FILE/', 'FILE/').replace(']]', '');
              } else if (href.startsWith('/public/FILE/')) {
                filePath = href.replace('/public', '');
              } else if (href.startsWith('/public/')) {
                filePath = href.replace('/public', '');
              }
            }
            
            if (isFileLink) {
              return (
                <a 
                  href={filePath}
                  download
                  className="inline-flex items-center gap-2 px-4 py-2 bg-zinc-800 text-zinc-100 rounded-lg hover:bg-zinc-700 transition-colors"
                  {...props}
                >
                  <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                  </svg>
                  {children}
                </a>
              );
            }
            
            return (
              <a 
                href={href}
                className="text-blue-600 dark:text-blue-400 hover:underline"
                {...props}
              >
                {children}
              </a>
            );
          }
        }}
      >
        {content}
      </ReactMarkdown>
    </div>
  );
}