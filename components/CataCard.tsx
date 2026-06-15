interface CataCardProps {
    title: string;
    url: string;
    description: string;
}

const CataCard = ({ title, url, description }: CataCardProps) => {
    return (
        <div className="group rounded-xl border-2 border-zinc-300 dark:border-zinc-600 bg-white dark:bg-zinc-900 p-5 shadow-md hover:shadow-xl transition-all duration-200 hover:-translate-y-1">
            <a href={url} className="block no-underline">
                <p className="text-lg font-bold text-zinc-900 dark:text-zinc-50 mb-2 group-hover:text-blue-600 dark:group-hover:text-blue-400 transition-colors">
                    {title}
                </p>
                <span className="text-sm leading-relaxed text-zinc-600 dark:text-zinc-400">
                    {description}
                </span>
            </a>
        </div>
    )
}

export default CataCard;