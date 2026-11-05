#!/usr/bin/env python3
"""Find complete local Sales Navigator notes without loading the full corpus."""
import argparse
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def notes():
    for path in sorted((ROOT / 'references').glob('articles-*.md')):
        text = path.read_text(encoding='utf-8')
        for block in re.split(r'(?m)(?=^## a\d+ — )', text)[1:]:
            block = re.sub(r'<a id="[^"]+"></a>\s*$', '', block).strip()
            title = block.splitlines()[0].removeprefix('## ')
            yield path, title, block


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('query', help='Article ID, title or keywords')
    p.add_argument('--limit', type=int, default=8)
    p.add_argument('--titles-only', action='store_true')
    a = p.parse_args()
    if not 1 <= a.limit <= 100:
        p.error('--limit must be between 1 and 100')
    q = a.query.casefold().strip()
    if not q:
        p.error('query must not be empty')
    terms = re.findall(r'[\w-]+', q)
    found = []
    for path, title, block in notes():
        low, tlow = block.casefold(), title.casefold()
        article_id = title.split(' ', 1)[0]
        if q == article_id:
            score = 10000
        elif q in tlow:
            score = 1000 + len(q)
        elif all(t in low for t in terms):
            score = 10 + sum(20 if t in tlow else 1 for t in terms)
        else:
            continue
        found.append((score, str(path.relative_to(ROOT)), title, block))
    found.sort(key=lambda x: (-x[0], x[2]))
    if not found:
        print('No matching bundled note. Try fewer keywords, the source index, or current official documentation.')
        return
    print(f'{len(found)} matching notes; showing {min(len(found), a.limit)}. Snapshot: 2026-11-05.\n')
    for _, path, title, block in found[:a.limit]:
        print(f'{title}\nFile: {path}' if a.titles_only else f'File: {path}\n{block}')
        print()


if __name__ == '__main__':
    main()
