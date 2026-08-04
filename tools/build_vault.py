#!/usr/bin/env python3
"""Build the V.A.U.L.T site.

Two jobs, both driven purely by the markdown in wiki/:

1. Refresh index.html — the FILES manifest and the embedded snapshot blocks,
   so new topic pages appear in the deck automatically and the file:// fallback
   never drifts from the live files.
2. Generate weekly.html — a dated, self-contained snapshot of the whole vault:
   this week's activity, every open loop, and the full text of every page.

Zero dependencies, standard library only:

    python3 tools/build_vault.py            # build with today's date
    python3 tools/build_vault.py --check    # fail if anything is out of date
    python3 tools/build_vault.py --date 2026-08-04
"""

import argparse
import datetime as dt
import html
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WIKI = ROOT / "wiki"

# Pillar/queue pages get curated deck metadata; anything else is a topic page
# and is described from its own content.
KNOWN = {
    "wiki/pending.md":      ("Tasks",           "T", "pillar", "Inbox, next actions, waiting on, scheduled — every open loop in one place."),
    "wiki/achievements.md": ("Achievements",    "A", "pillar", "Wins and milestones worth remembering, filed by month with what, impact, links."),
    "wiki/goals.md":        ("Vision",          "V", "pillar", "Goals & active projects — where all of this is heading."),
    "wiki/index.md":        ("Understanding",   "U", "pillar", "The knowledge catalog — one page per topic, compounding with every ingest."),
    "wiki/decisions.md":    ("Log · Decisions", "L", "pillar", "Why choices were made — with context and options, never rewritten."),
    "wiki/log.md":          ("Log · History",   "L", "pillar", "Append-only record of everything the vault has ever done."),
    "wiki/ideas.md":        ("Ideas",           "I", "queue",  "Someday / maybe — parked without guilt, promoted when the time is right."),
    "wiki/reading-list.md": ("Reading list",    "R", "queue",  "Sources queued for ingestion into Understanding."),
    "CLAUDE.md":            ("Schema",          "§", "system", "The rulebook — operations, formats, and conventions the vault follows."),
}
ORDER = list(KNOWN)


# --------------------------------------------------------------------------
# vault model
# --------------------------------------------------------------------------

def read(path):
    return (ROOT / path).read_text(encoding="utf-8")


def discover():
    """Every markdown file in the vault, curated pages first."""
    files = []
    for path in ORDER:
        if (ROOT / path).exists():
            title, letter, group, desc = KNOWN[path]
            files.append(dict(path=path, title=title, letter=letter, group=group, desc=desc))
    for md in sorted(WIKI.glob("*.md")):
        rel = f"wiki/{md.name}"
        if rel in KNOWN:
            continue
        src = read(rel)
        m = re.search(r"^# +(.*)$", src, re.M)
        title = m.group(1).strip() if m else md.stem.replace("-", " ").title()
        files.append(dict(
            path=rel, title=title, letter=title[:1].upper(), group="topic",
            desc=first_sentence(src),
        ))
    return files


def first_sentence(src, limit=120):
    for line in strip_comments(src).split("\n"):
        line = line.strip()
        if not line or line.startswith(("#", "|", ">", "-", "*", "`")):
            continue
        line = re.sub(r"[*`\[\]]", "", line)
        if len(line) > limit:
            line = line[:limit].rsplit(" ", 1)[0] + "…"
        return line
    return "A knowledge page in the vault."


def strip_comments(src):
    return re.sub(r"<!--.*?-->", "", src, flags=re.S)


def section(src, heading):
    """Body of a `## <heading>` section, matched exactly."""
    for part in re.split(r"^## +", src, flags=re.M)[1:]:
        if part.split("\n", 1)[0].strip().lower() == heading.lower():
            return part
    return ""


def tags_of(src):
    body = re.sub(r"```.*?```", "", src, flags=re.S)
    body = re.sub(r"`[^`]*`", "", body)
    seen, out = set(), []
    for m in re.finditer(r"(?:^|[\s(])#([a-zA-Z0-9][\w/-]*)", body):
        t = m.group(1).lower()
        if t not in seen:
            seen.add(t)
            out.append(t)
    return out


def stats(files, today):
    pend = read("wiki/pending.md") if (ROOT / "wiki/pending.md").exists() else ""
    log = read("wiki/log.md") if (ROOT / "wiki/log.md").exists() else ""
    goals = read("wiki/goals.md") if (ROOT / "wiki/goals.md").exists() else ""
    ach = read("wiki/achievements.md") if (ROOT / "wiki/achievements.md").exists() else ""
    ideas = read("wiki/ideas.md") if (ROOT / "wiki/ideas.md").exists() else ""
    reading = read("wiki/reading-list.md") if (ROOT / "wiki/reading-list.md").exists() else ""
    dec = read("wiki/decisions.md") if (ROOT / "wiki/decisions.md").exists() else ""

    open_re = re.compile(r"^[ \t]*- \[ \]", re.M)
    overdue = [m.group(1) for m in re.finditer(r"^[ \t]*- \[ \].*?📅 (\d{4}-\d{2}-\d{2})", pend, re.M)
               if m.group(1) < today]
    reviews = re.findall(r"^\[REVIEW\] (\d{4}-\d{2}-\d{2})", log, re.M)
    return dict(
        open=len(open_re.findall(pend)),
        inbox=len(open_re.findall(section(pend, "Inbox"))),
        next_actions=len(open_re.findall(section(pend, "Next actions"))),
        waiting=len(open_re.findall(section(pend, "Waiting on"))),
        overdue=len(overdue),
        wins=len(re.findall(r"^### 🏆", ach, re.M)),
        goals=len(re.findall(r"^### ", section(goals, "Active"), re.M)),
        decisions=len(re.findall(r"^### \d{4}", dec, re.M)),
        ideas=len(re.findall(r"^- ", re.split(r"^## +Cross", ideas, flags=re.M)[0], re.M)),
        reading=len(re.findall(r"^\| \d{4}", section(reading, "To read / ingest"), re.M)),
        log_entries=len(re.findall(r"^\[[A-Z]+\]", log, re.M)),
        topics=len([f for f in files if f["group"] == "topic"]),
        last_review=max(reviews) if reviews else None,
    )


def week_activity(today, days=7):
    """Log lines from the last `days` days, newest first."""
    log = read("wiki/log.md") if (ROOT / "wiki/log.md").exists() else ""
    since = (dt.date.fromisoformat(today) - dt.timedelta(days=days)).isoformat()
    rows = []
    for line in log.split("\n"):
        m = re.match(r"^\[([A-Z]+)\] (\d{4}-\d{2}-\d{2}) — (.*)$", line.strip())
        if m and m.group(2) > since:
            rows.append(dict(kind=m.group(1), date=m.group(2), text=m.group(3)))
    return sorted(rows, key=lambda r: r["date"], reverse=True)


# --------------------------------------------------------------------------
# markdown → html (static renderer for the digest)
# --------------------------------------------------------------------------

def esc(s):
    return html.escape(s, quote=True)


def inline(s, slugs):
    """Inline markdown. Code spans / wikilinks / links are stashed as tokens so
    later transforms cannot corrupt them (same approach as the site renderer)."""
    toks = []

    def stash(h):
        toks.append(h)
        return f"\x00{len(toks) - 1}\x00"

    s = esc(s)
    s = re.sub(r"`([^`]+)`", lambda m: stash(f"<code>{m.group(1)}</code>"), s)

    def wl(m):
        name = m.group(1).strip()
        key = name.lower()
        if key in slugs:
            return stash(f'<a class="wl" href="#file-{slugs[key]}">{name}</a>')
        return stash(f'<span class="wl--dead">{name}</span>')

    s = re.sub(r"\[\[([^\]]+)\]\]", wl, s)

    def link(m):
        text, url = m.group(1), m.group(2)
        if not url.startswith(("http://", "https://")):
            return stash(text)
        return stash(f'<a href="{url}" target="_blank" rel="noopener">{text}</a>')

    s = re.sub(r"\[([^\]]+)\]\(([^)\s]+)\)", link, s)
    s = re.sub(r"\*\*([^*]+)\*\*", r"<b>\1</b>", s)
    s = re.sub(r"(^|[\s(])\*([^*\n]+)\*", r"\1<em>\2</em>", s)
    # Tags must start a word — the leading-boundary guard also keeps this from
    # matching inside HTML entities such as &#x27; produced by esc().
    s = re.sub(r"(^|[\s(])#([a-zA-Z0-9][\w/-]*)", r'\1<span class="tag">#\2</span>', s)
    return re.sub(r"\x00(\d+)\x00", lambda m: toks[int(m.group(1))], s)


def md_to_html(src, slugs):
    src = strip_comments(src)
    lines = src.split("\n")
    out, i = [], 0

    def is_table(l):
        return bool(re.match(r"^\s*\|.*\|\s*$", l))

    while i < len(lines):
        line = lines[i]
        if line.startswith("```"):
            i += 1
            code = []
            while i < len(lines) and not lines[i].startswith("```"):
                code.append(lines[i])
                i += 1
            i += 1
            out.append("<pre><code>" + esc("\n".join(code)) + "</code></pre>")
            continue
        m = re.match(r"^(#{1,6}) +(.*)$", line)
        if m:
            lvl = min(len(m.group(1)), 4)
            out.append(f"<h{lvl}>{inline(m.group(2), slugs)}</h{lvl}>")
            i += 1
            continue
        if re.match(r"^\s*(-{3,}|\*{3,})\s*$", line):
            out.append("<hr>")
            i += 1
            continue
        if line.startswith(">"):
            bq = []
            while i < len(lines) and lines[i].startswith(">"):
                bq.append(re.sub(r"^>\s?", "", lines[i]))
                i += 1
            out.append("<blockquote>" + inline(" ".join(bq), slugs) + "</blockquote>")
            continue
        if is_table(line):
            rows = []
            while i < len(lines) and is_table(lines[i]):
                rows.append(lines[i])
                i += 1
            has_head = len(rows) > 1 and re.match(r"^\s*\|[\s:|-]+\|\s*$", rows[1])
            buf = ["<table>"]
            for ri, r in enumerate(rows):
                if has_head and ri == 1:
                    continue
                r = re.sub(r"`[^`]*`", lambda m: m.group(0).replace("|", "\x01"), r)
                cells = re.sub(r"\|\s*$", "", re.sub(r"^\s*\|", "", r)).split("|")
                tag = "th" if (has_head and ri == 0) else "td"
                buf.append("<tr>" + "".join(
                    f"<{tag}>{inline(c.strip().replace(chr(1), '|'), slugs)}</{tag}>" for c in cells
                ) + "</tr>")
            buf.append("</table>")
            out.append("".join(buf))
            continue
        if re.match(r"^\s*[-*] +", line):
            items = []
            while i < len(lines) and re.match(r"^\s*[-*] +", lines[i]):
                body = re.sub(r"^\s*[-*] +", "", lines[i])
                task = re.match(r"^\[([ xX])\] *(.*)$", body)
                if task:
                    done = task.group(1).lower() == "x"
                    cls = "task done" if done else "task"
                    items.append(f'<li class="{cls}"><span class="cb"></span>'
                                 f"<span>{inline(task.group(2), slugs)}</span></li>")
                else:
                    items.append(f"<li>{inline(body, slugs)}</li>")
                i += 1
            out.append("<ul>" + "".join(items) + "</ul>")
            continue
        if re.match(r"^\s*\d+\. +", line):
            items = []
            while i < len(lines) and re.match(r"^\s*\d+\. +", lines[i]):
                items.append("<li>" + inline(re.sub(r"^\s*\d+\. +", "", lines[i]), slugs) + "</li>")
                i += 1
            out.append("<ol>" + "".join(items) + "</ol>")
            continue
        if not line.strip():
            i += 1
            continue
        # a line of nothing but #tags — shown as chips in the page header
        if re.match(r"^\s*#[A-Za-z0-9][\w/-]*(\s+#[A-Za-z0-9][\w/-]*)*\s*$", line):
            i += 1
            continue
        para = []
        while (i < len(lines) and lines[i].strip()
               and not re.match(r"^(#{1,6} |```|>|\s*[-*] |\s*\d+\. )", lines[i])
               and not is_table(lines[i])
               and not re.match(r"^\s*(-{3,}|\*{3,})\s*$", lines[i])):
            para.append(lines[i])
            i += 1
        out.append("<p>" + inline(" ".join(para), slugs) + "</p>")
    return "\n".join(out)


# --------------------------------------------------------------------------
# index.html regeneration
# --------------------------------------------------------------------------

def js_str(s):
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"') + '"'


def render_manifest(files):
    w_path = max(len(f["path"]) for f in files) + 2
    w_title = max(len(f["title"]) for f in files) + 2
    rows = []
    for f in files:
        rows.append(
            "    {{ path:{p:<{wp}} title:{t:<{wt}} letter:{l}, group:{g}, desc:{d} }}".format(
                p=js_str(f["path"]) + ",", wp=w_path + 2,
                t=js_str(f["title"]) + ",", wt=w_title + 2,
                l=js_str(f["letter"]), g=js_str(f["group"]), d=js_str(f["desc"]),
            )
        )
    return ("  /* BUILD:FILES:START — generated by tools/build_vault.py */\n"
            "  var FILES = [\n" + ",\n".join(rows) + "\n  ];\n"
            "  /* BUILD:FILES:END */")


def render_snapshots(files):
    blocks = ["<!-- BUILD:SNAPSHOTS:START -->"]
    for f in files:
        body = read(f["path"]).rstrip("\n")
        if "</script" in body.lower():
            sys.exit(f"refusing to embed {f['path']}: contains a </script> sequence")
        blocks.append(f'<script type="text/markdown" data-file="{f["path"]}">\n{body}\n</script>')
    blocks.append("<!-- BUILD:SNAPSHOTS:END -->")
    return "\n".join(blocks)


def build_index(files):
    path = ROOT / "index.html"
    src = path.read_text(encoding="utf-8")
    src = re.sub(r"  /\* BUILD:FILES:START.*?/\* BUILD:FILES:END \*/",
                 lambda _: render_manifest(files), src, flags=re.S)
    src = re.sub(r"<!-- BUILD:SNAPSHOTS:START -->.*?<!-- BUILD:SNAPSHOTS:END -->",
                 lambda _: render_snapshots(files), src, flags=re.S)
    return path, src


# --------------------------------------------------------------------------
# weekly.html
# --------------------------------------------------------------------------

KIND_LABEL = {
    "INGEST": "Ingested", "QUERY": "Filed", "LINT": "Linted", "UPDATE": "Updated",
    "CAPTURE": "Captured", "DONE": "Completed", "ACHIEVE": "Achievement",
    "DECIDE": "Decision", "REVIEW": "Review",
}


def build_weekly(files, today):
    st = stats(files, today)
    acts = week_activity(today)
    d = dt.date.fromisoformat(today)
    week_start = (d - dt.timedelta(days=6)).isoformat()
    slugs = {Path(f["path"]).stem.lower(): Path(f["path"]).stem.lower() for f in files}

    def tile(label, value, hot=False):
        cls = ' class="hot"' if hot else ""
        return f"<div{cls}><dt>{label}</dt><dd>{value}</dd></div>"

    tiles = "".join([
        tile("Open tasks", st["open"]),
        tile("In inbox", st["inbox"]),
        tile("Overdue", st["overdue"], st["overdue"] > 0),
        tile("Waiting on", st["waiting"]),
        tile("Wins", st["wins"]),
        tile("Active goals", st["goals"]),
        tile("Decisions", st["decisions"]),
        tile("Queued reading", st["reading"]),
    ])

    if acts:
        act_rows = "".join(
            f'<li><span class="kind kind--{a["kind"].lower()}">{KIND_LABEL.get(a["kind"], a["kind"])}</span>'
            f'<span class="when">{a["date"]}</span>'
            f'<span class="what">{inline(a["text"], slugs)}</span></li>'
            for a in acts
        )
        activity = f'<ul class="activity">{act_rows}</ul>'
    else:
        activity = ('<p class="quiet">No entries logged between '
                    f"{week_start} and {today}. A quiet week — or a week the vault "
                    "wasn't told about.</p>")

    pend = read("wiki/pending.md")
    open_items = [l.strip() for l in pend.split("\n") if re.match(r"^[ \t]*- \[ \]", l)]
    if open_items:
        loops = "<ul>" + "".join(
            "<li>" + inline(re.sub(r"^[ \t]*- \[ \] *", "", l), slugs) + "</li>" for l in open_items
        ) + "</ul>"
    else:
        loops = '<p class="quiet">No open loops. Inbox at zero.</p>'

    sections = []
    for f in files:
        anchor = Path(f["path"]).stem.lower()
        body = md_to_html(read(f["path"]), slugs)
        tags = "".join(f'<span class="tag">#{t}</span>' for t in tags_of(read(f["path"])))
        sections.append(
            f'<section class="page" id="file-{anchor}">'
            f'<header class="page__head"><p class="page__path">{f["path"]}</p>'
            f'<h2>{esc(f["title"])}</h2><div class="page__tags">{tags}</div></header>'
            f'<div class="md">{body}</div></section>'
        )

    toc = "".join(
        f'<li><a href="#file-{Path(f["path"]).stem.lower()}">{esc(f["title"])}'
        f'<span>{f["path"]}</span></a></li>' for f in files
    )
    review_note = (f"Last weekly review logged {st['last_review']}."
                   if st["last_review"] else
                   "No weekly review logged yet — say “weekly review” to run the first one.")

    return ROOT / "weekly.html", WEEKLY_TEMPLATE.format(
        today=today, week_start=week_start,
        year=d.isocalendar()[0], week=f"{d.isocalendar()[1]:02d}",
        tiles=tiles, activity=activity, loops=loops, sections="".join(sections),
        toc=toc, review_note=esc(review_note), file_count=len(files),
        log_entries=st["log_entries"], topics=st["topics"],
    )


WEEKLY_TEMPLATE = """<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="V.A.U.L.T weekly digest — {today}. Everything in the vault: the week's activity, every open loop, and the full text of all pages.">
<meta name="theme-color" content="#10161a">
<link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20'%3E%3Ccircle cx='10' cy='10' r='7.4' stroke='%23f06d0c' stroke-width='1.8' fill='none'/%3E%3Ccircle cx='10' cy='10' r='2.6' fill='%23f06d0c'/%3E%3C/svg%3E">
<title>V.A.U.L.T — weekly digest {today}</title>
<style>
:root{{
  --bg:#10161a; --bg-2:#151d21; --bg-3:#1b252b;
  --ink:#edf1f4; --ink-dim:#c0c9cf; --muted:#7f8b94;
  --accent:#f06d0c; --accent-soft:#ffb36b; --accent-tint:#ffe1c3;
  --green:#80a45d; --blue:#0064a0;
  --line:rgba(221,225,228,.14); --line-soft:rgba(221,225,228,.08);
  --serif:Georgia,"Times New Roman",serif;
  --sans:"Segoe UI",-apple-system,BlinkMacSystemFont,Helvetica,Arial,sans-serif;
  --mono:"Cascadia Code",Consolas,"SF Mono",Menlo,monospace;
}}
*,*::before,*::after{{ margin:0; padding:0; box-sizing:border-box; }}
body{{ background:var(--bg); color:var(--ink); font-family:var(--sans); font-size:16px; line-height:1.6; -webkit-font-smoothing:antialiased; }}
::selection{{ background:var(--accent); color:#10161a; }}
a{{ color:inherit; text-decoration:none; }}
ul{{ list-style:none; }}
.wrap{{ max-width:1100px; margin:0 auto; padding:0 clamp(1.2rem,4vw,3rem); }}

.masthead{{ border-bottom:1px solid var(--line-soft); padding:clamp(3rem,9vh,6rem) 0 clamp(2rem,5vh,3rem); }}
.brand{{ font-family:var(--serif); font-size:1.05rem; letter-spacing:.16em; }}
.brand i{{ font-style:normal; color:var(--accent); }}
.eyebrow{{ display:flex; align-items:center; gap:1rem; font-size:.72rem; letter-spacing:.35em; text-transform:uppercase; color:var(--accent); margin:2.2rem 0 1.4rem; }}
.eyebrow::before{{ content:""; width:3rem; height:1px; background:var(--accent); }}
h1{{ font-family:var(--serif); font-weight:400; font-size:clamp(2.2rem,6vw,4.6rem); line-height:1.04; letter-spacing:-.025em; }}
h1 em{{ font-style:italic; color:var(--accent-soft); }}
.dek{{ color:var(--ink-dim); max-width:60ch; margin-top:1.4rem; }}
.dek b{{ color:var(--ink); font-weight:600; }}

.stats{{ display:grid; grid-template-columns:repeat(4,1fr); gap:1px; background:var(--line-soft); border:1px solid var(--line-soft); margin-top:clamp(2.4rem,6vh,3.4rem); }}
.stats div{{ background:var(--bg-2); padding:1.3rem 1.4rem; }}
.stats dt{{ font-size:.6rem; letter-spacing:.26em; text-transform:uppercase; color:var(--muted); margin-bottom:.5rem; }}
.stats dd{{ font-family:var(--serif); font-size:clamp(1.7rem,3vw,2.4rem); line-height:1; font-variant-numeric:tabular-nums; }}
.stats div.hot dd{{ color:var(--accent-soft); }}
@media (max-width:860px){{ .stats{{ grid-template-columns:repeat(2,1fr); }} }}

section.block{{ padding:clamp(3rem,7vh,5rem) 0; border-bottom:1px solid var(--line-soft); }}
.block__head{{ display:flex; align-items:baseline; justify-content:space-between; gap:2rem; border-bottom:1px solid var(--line-soft); padding-bottom:1.1rem; margin-bottom:2rem; }}
.label{{ font-size:.7rem; letter-spacing:.32em; text-transform:uppercase; color:var(--accent); }}
.num{{ font-family:var(--serif); font-style:italic; color:var(--muted); font-size:.9rem; }}
h2.block__title{{ font-family:var(--serif); font-weight:400; font-size:clamp(1.7rem,3.4vw,2.6rem); letter-spacing:-.02em; margin-bottom:1.4rem; }}
h2.block__title em{{ color:var(--accent-soft); }}
.quiet{{ color:var(--muted); font-style:italic; }}

.activity li{{ display:grid; grid-template-columns:9.5rem 6.5rem 1fr; gap:1.2rem; align-items:baseline; padding:.75rem 0; border-bottom:1px solid var(--line-soft); font-size:.94rem; color:var(--ink-dim); }}
.activity li:last-child{{ border-bottom:0; }}
.kind{{ font-size:.6rem; letter-spacing:.2em; text-transform:uppercase; color:var(--ink-dim); border:1px solid var(--line); padding:.35em .8em; border-radius:99px; text-align:center; }}
.kind--achieve,.kind--done{{ color:var(--green); border-color:rgba(128,164,93,.4); }}
.kind--decide{{ color:var(--accent-soft); border-color:rgba(240,109,12,.4); }}
.kind--review{{ color:var(--accent-tint); border-color:rgba(240,109,12,.55); }}
.when{{ font-family:var(--mono); font-size:.75rem; color:var(--muted); }}
@media (max-width:700px){{ .activity li{{ grid-template-columns:1fr; gap:.3rem; }} .kind{{ justify-self:start; }} }}

.toc{{ display:grid; grid-template-columns:repeat(3,1fr); gap:1px; background:var(--line-soft); border:1px solid var(--line-soft); }}
.toc li a{{ display:block; background:var(--bg-2); padding:1.1rem 1.3rem; transition:background .3s; }}
.toc li a:hover{{ background:var(--bg-3); }}
.toc li span{{ display:block; font-family:var(--mono); font-size:.65rem; color:var(--muted); margin-top:.25rem; }}
@media (max-width:860px){{ .toc{{ grid-template-columns:1fr 1fr; }} }}
@media (max-width:520px){{ .toc{{ grid-template-columns:1fr; }} }}

.page{{ padding:clamp(2.6rem,6vh,4rem) 0; border-bottom:1px solid var(--line-soft); }}
.page__head{{ margin-bottom:1.6rem; }}
.page__path{{ font-family:var(--mono); font-size:.68rem; color:var(--accent-soft); }}
.page__head h2{{ font-family:var(--serif); font-weight:400; font-size:clamp(1.6rem,3vw,2.2rem); letter-spacing:-.02em; margin-top:.2rem; }}
.page__tags{{ display:flex; gap:.4rem; flex-wrap:wrap; margin-top:.7rem; }}
.tag{{ font-family:var(--mono); font-size:.62rem; color:var(--accent-soft); border:1px solid rgba(240,109,12,.35); padding:.25em .7em; border-radius:99px; }}

.md{{ font-size:.95rem; color:var(--ink-dim); }}
.md > *+*{{ margin-top:.9em; }}
.md h1{{ font-family:var(--serif); font-weight:400; color:var(--ink); font-size:1.6rem; letter-spacing:-.02em; }}
.md h2{{ font-family:var(--serif); font-weight:400; color:var(--ink); font-size:1.3rem; margin-top:1.7em; padding-bottom:.4em; border-bottom:1px solid var(--line-soft); }}
.md h3{{ font-family:var(--serif); font-weight:400; color:var(--ink); font-size:1.1rem; margin-top:1.4em; }}
.md h4{{ font-size:.7rem; letter-spacing:.26em; text-transform:uppercase; color:var(--accent); margin-top:1.5em; }}
.md b{{ color:var(--ink); font-weight:600; }}
.md em{{ color:var(--accent-soft); }}
.md ul,.md ol{{ padding-left:1.3em; }}
.md ol{{ list-style:decimal; }}
.md ul li,.md ol li{{ padding:.26em 0; position:relative; }}
.md ul li:not(.task)::before{{ content:"›"; position:absolute; left:-1.15em; color:var(--accent); font-family:var(--serif); }}
.md li.task{{ display:flex; gap:.7em; align-items:baseline; }}
.md li.task::before{{ display:none; }}
.md li.task .cb{{ flex-shrink:0; width:.85em; height:.85em; transform:translateY(.08em); border:1px solid var(--muted); border-radius:2px; display:inline-block; position:relative; }}
.md li.task.done{{ color:var(--muted); }}
.md li.task.done .cb{{ background:var(--green); border-color:var(--green); }}
.md li.task.done .cb::after{{ content:"✓"; position:absolute; inset:0; color:#10161a; font-size:.7em; line-height:1.2; text-align:center; font-weight:700; }}
.md code{{ font-family:var(--mono); font-size:.85em; color:var(--accent-tint); background:rgba(240,109,12,.08); padding:.15em .45em; border-radius:3px; }}
.md pre{{ background:var(--bg); border:1px solid var(--line-soft); border-radius:4px; padding:1.1em 1.3em; overflow-x:auto; font-family:var(--mono); font-size:.8rem; line-height:1.6; }}
.md pre code{{ background:none; padding:0; color:inherit; }}
.md table{{ border-collapse:collapse; width:100%; font-size:.88rem; display:block; overflow-x:auto; }}
.md th{{ text-align:left; font-size:.62rem; letter-spacing:.22em; text-transform:uppercase; color:var(--accent); padding:.55em .9em; border-bottom:1px solid var(--line); }}
.md td{{ padding:.55em .9em; border-bottom:1px solid var(--line-soft); vertical-align:top; }}
.md blockquote{{ border-left:2px solid var(--accent); padding:.4em 0 .4em 1.2em; background:rgba(240,109,12,.05); font-style:italic; }}
.md hr{{ border:0; border-top:1px solid var(--line-soft); margin:1.5em 0; }}
.md a{{ color:var(--accent-soft); border-bottom:1px solid rgba(240,109,12,.4); }}
.md .wl{{ font-weight:600; }}
.md .wl--dead{{ color:var(--muted); border-bottom:1px dashed var(--line); }}

footer{{ padding:clamp(2.5rem,6vh,4rem) 0 3rem; color:var(--muted); font-size:.7rem; letter-spacing:.18em; text-transform:uppercase; display:flex; justify-content:space-between; gap:1.5rem; flex-wrap:wrap; }}
footer a{{ color:var(--accent-soft); }}

@media print{{
  body{{ background:#fff; color:#111; }}
  .masthead,.block,.page{{ break-inside:avoid; }}
  .stats div,.toc li a{{ background:#fff; }}
  .md,.dek,.activity li{{ color:#222; }}
  h1,.md h1,.md h2,.md h3,.page__head h2{{ color:#000; }}
  a{{ color:#000; }}
  .toc{{ display:none; }}
}}
</style>
</head>
<body>

<header class="masthead">
  <div class="wrap">
    <p class="brand">V<i>.</i>A<i>.</i>U<i>.</i>L<i>.</i>T</p>
    <p class="eyebrow">Weekly digest · {week_start} → {today}</p>
    <h1>Week {week}, <em>{year}.</em></h1>
    <p class="dek">Everything in the vault, as of <b>{today}</b> — the week's activity, every open
    loop, and the full text of all <b>{file_count} files</b>. Self-contained: no server, no
    dependencies, prints cleanly. {review_note}</p>
    <dl class="stats">{tiles}</dl>
  </div>
</header>

<main class="wrap">

<section class="block">
  <div class="block__head"><span class="label">This week</span><span class="num">01 / 03</span></div>
  <h2 class="block__title">What <em>happened.</em></h2>
  {activity}
</section>

<section class="block">
  <div class="block__head"><span class="label">Open loops</span><span class="num">02 / 03</span></div>
  <h2 class="block__title">What's <em>still open.</em></h2>
  <div class="md">{loops}</div>
</section>

<section class="block">
  <div class="block__head"><span class="label">Contents</span><span class="num">03 / 03</span></div>
  <h2 class="block__title">Everything <em>you have.</em></h2>
  <ul class="toc">{toc}</ul>
</section>

{sections}

</main>

<footer class="wrap">
  <span>V.A.U.L.T weekly digest · generated {today}</span>
  <span>{log_entries} log entries · {topics} topic pages</span>
  <span><a href="index.html">← Back to the live vault</a></span>
</footer>

</body>
</html>
"""


# --------------------------------------------------------------------------

def main():
    ap = argparse.ArgumentParser(description="Build the V.A.U.L.T site and weekly digest.")
    ap.add_argument("--date", default=dt.date.today().isoformat(),
                    help="build date, YYYY-MM-DD (default: today)")
    ap.add_argument("--check", action="store_true",
                    help="exit 1 if any output is out of date; write nothing")
    args = ap.parse_args()

    files = discover()
    outputs = [build_index(files), build_weekly(files, args.date)]

    stale = []
    for path, content in outputs:
        current = path.read_text(encoding="utf-8") if path.exists() else None
        if current == content:
            continue
        stale.append(path.relative_to(ROOT))
        if not args.check:
            path.write_text(content, encoding="utf-8")

    if args.check:
        if stale:
            print("out of date: " + ", ".join(str(p) for p in stale))
            return 1
        print(f"up to date — {len(files)} files")
        return 0

    print(f"built {len(files)} files → " +
          (", ".join(str(p) for p in stale) if stale else "no changes"))
    return 0


if __name__ == "__main__":
    sys.exit(main())
