// Builds api/notes.json from the skill's article notes, so the notes keep one source.
import { readdirSync, readFileSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const here = dirname(fileURLToPath(import.meta.url));
const refs = join(here, "../../skills/linkedin-sales-navigator/references");
const notes = [];

for (const file of readdirSync(refs).filter((f) => /^articles-.*\.md$/.test(f))) {
  const topic = file.replace(/^articles-|\.md$/g, "");
  const text = readFileSync(join(refs, file), "utf8");
  for (const raw of text.split(/^(?=## a\d+ — )/m).slice(1)) {
    const lines = raw.replace(/<a id="[^"]+"><\/a>\s*$/, "").trim().split("\n");
    const [, id, title] = lines[0].match(/^## (a\d+) — (.*)$/);
    const field = (name) =>
      lines.find((l) => l.startsWith(`${name}: `))?.slice(name.length + 2) ?? null;
    const body = lines
      .slice(1)
      .filter((l) => !/^(Source|Reviewed?): /.test(l))
      .join("\n")
      .trim();
    notes.push({ id, title, topic, source_url: field("Source"), body });
  }
}

notes.sort((a, b) => a.id.localeCompare(b.id));
writeFileSync(join(here, "../lib/notes.json"), JSON.stringify(notes));
console.log(`Built ${notes.length} notes`);
