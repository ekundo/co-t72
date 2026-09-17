#!/usr/bin/env python3
"""CO.HLP из docs/co-help.md.

Источник правды -- маркдаун; здесь он раскладывается по колонкам так, как это
делал автор справки: КОИ-8, CRLF, ширина 79, абзац с отступа в пять пробелов,
выключка по обоим краям.

Что во что превращается:

    # заголовок           -- заголовок файла, в CO.HLP не идет
    <!-- co-help:skip --> -- и все до <!-- /co-help:skip --> тоже не идет
    ## заголовок          -- отдельной строкой по центру
    абзац                 -- отступ 5, продолжение от левого края
    - пункт               -- то же, что абзац
      - подпункт          -- отступ 8, продолжение от левого края
    ``` ... ```           -- как есть, с отступом 8
    ```screen ... ```     -- как есть, без отступа
    ```center ... ```     -- как есть, по центру

Пустая строка в маркдауне дает пустую строку в CO.HLP -- кроме той, что нужна
самому маркдауну и ничего не значит: между двумя абзацами и перед продолжением
абзаца внутри пункта. Абзац и так начинается с отступа, и в исходной справке
пустой строки между абзацами нет. Нужна пустая строка в этом месте -- оставьте
две.
"""
import argparse, pathlib, re

WIDTH = 79


def justify(words, width, indent, last):
    """Строка из слов с выключкой по обоим краям; last -- последняя в абзаце."""
    text = ' '.join(words)
    if last or len(words) == 1:
        return ' ' * indent + text
    slack = width - indent - len(text)
    gaps = len(words) - 1
    if slack <= 0:
        return ' ' * indent + text
    add, extra = divmod(slack, gaps)
    out = ''
    for i, w in enumerate(words):
        out += w
        if i < gaps:
            # остаток -- в правые промежутки, как в исходной справке
            out += ' ' * (1 + add + (1 if i >= gaps - extra else 0))
    return ' ' * indent + out


def wrap(text, first_indent):
    """Абзац по колонкам: первая строка с отступа, остальные от левого края."""
    words = text.split()
    lines, cur, indent = [], [], first_indent
    for w in words:
        cand = cur + [w]
        if len(' '.join(cand)) + indent > WIDTH and cur:
            lines.append((cur, indent))
            cur, indent = [w], 0
        else:
            cur = cand
    if cur:
        lines.append((cur, indent))
    return [justify(ws, WIDTH, ind, i == len(lines) - 1)
            for i, (ws, ind) in enumerate(lines)]


def render(md):
    out, i = [], 0
    lines = md.split('\n')
    skip = False
    para = None          # (отступ, текст)
    pending_blank = 0
    in_item = False      # последний блок -- пункт списка
    last_para = False    # последний блок -- абзац

    def flush():
        nonlocal para
        if para is not None:
            out.extend(wrap(para[1], para[0]))
            para = None

    while i < len(lines):
        l = lines[i]
        s = l.strip()
        if s == '<!-- co-help:skip -->':
            skip = True
            i += 1
            continue
        if s == '<!-- /co-help:skip -->':
            skip = False
            pending_blank = 0
            i += 1
            continue
        if skip:
            i += 1
            continue
        if s.startswith('```'):
            kind = s[3:].strip()
            body = []
            i += 1
            while i < len(lines) and not lines[i].strip().startswith('```'):
                body.append(lines[i])
                i += 1
            i += 1
            flush()
            out.extend([''] * pending_blank)
            pending_blank = 0
            for b in body:
                if kind == 'screen':
                    out.append(b)
                elif kind == 'center':
                    t = b.strip()
                    out.append(' ' * max(0, (WIDTH - len(t)) // 2) + t)
                else:
                    out.append((' ' * 8 + b).rstrip() if b.strip() else '')
            in_item = False
            last_para = False
            continue
        if not s:
            flush()
            pending_blank += 1
            i += 1
            continue
        if l.startswith('# '):
            i += 1
            continue
        if l.startswith('## '):
            flush()
            out.extend([''] * pending_blank)
            pending_blank = 0
            t = l[3:].strip()
            out.append(' ' * max(0, (WIDTH - len(t)) // 2) + t)
            in_item = False
            last_para = False
            i += 1
            continue
        m = re.match(r'^(\s*)- (.*)$', l)
        if m:
            flush()
            out.extend([''] * pending_blank)
            pending_blank = 0
            para = (8 if len(m.group(1)) >= 2 else 5, m.group(2).strip())
            in_item = True
            last_para = False
            i += 1
            continue
        if para is not None:
            para = (para[0], para[1] + ' ' + s)
            i += 1
            continue
        # начало абзаца
        if (last_para or (l.startswith('  ') and in_item)) and pending_blank:
            pending_blank -= 1         # эта пустая строка нужна была маркдауну
        out.extend([''] * pending_blank)
        pending_blank = 0
        para = (5, s)
        in_item = False
        last_para = True
        i += 1
    flush()
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('md')
    ap.add_argument('-o', '--out', required=True)
    a = ap.parse_args()
    lines = render(pathlib.Path(a.md).read_text())
    while lines and not lines[0]:
        lines.pop(0)
    while lines and not lines[-1]:
        lines.pop()
    text = '\r\n'.join(lines) + '\r\n'
    data = text.encode('koi8-r')
    if len(data) % 128:
        data += b'\x1a' * (128 - len(data) % 128)
    pathlib.Path(a.out).write_bytes(data)
    print(f'{a.out}: {len(data)} байт, {len(lines)} строк')


if __name__ == '__main__':
    main()
