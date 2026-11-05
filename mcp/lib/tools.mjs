import { readFileSync } from "node:fs";

const notes = JSON.parse(
  readFileSync(new URL("./notes.json", import.meta.url), "utf8"),
);

const summarize = (note, body = note.body) => ({
  article_id: note.id,
  title: note.title,
  topic: note.topic,
  source_url: note.source_url,
  snippet: body.length > 240 ? `${body.slice(0, 240)}...` : body,
});

export function searchNotes(query, limit = 5) {
  const q = query.trim().toLowerCase();
  const terms = q.match(/[\p{L}\p{N}-]+/gu) ?? [];
  const scored = [];
  for (const note of notes) {
    const title = note.title.toLowerCase();
    const text = `${title}\n${note.body.toLowerCase()}`;
    let score;
    if (note.id === q) score = 10000;
    else if (title.includes(q)) score = 1000 + q.length;
    else if (terms.length && terms.every((t) => text.includes(t))) {
      score = 10 + terms.reduce((n, t) => n + (title.includes(t) ? 20 : 1), 0);
    } else continue;
    scored.push({ score, note });
  }
  scored.sort((a, b) => b.score - a.score || a.note.title.localeCompare(b.note.title));
  return {
    total_matches: scored.length,
    results: scored.slice(0, limit).map(({ note }) => summarize(note)),
  };
}

export function getNote(articleId) {
  const note = notes.find((n) => n.id === articleId.trim().toLowerCase());
  if (!note) return null;
  return {
    article_id: note.id,
    title: note.title,
    topic: note.topic,
    source_url: note.source_url,
    note: note.body,
  };
}

export function listTopics() {
  const counts = new Map();
  for (const { topic } of notes) counts.set(topic, (counts.get(topic) ?? 0) + 1);
  return {
    total_notes: notes.length,
    topics: [...counts].sort().map(([topic, note_count]) => ({ topic, note_count })),
  };
}

// Syntax rules come from the note on LinkedIn's Boolean search article (a168061).
export function checkBooleanQuery(query) {
  const issues = [];
  const add = (severity, code, message) => issues.push({ severity, code, message });

  let normalized = query.replace(/[“”]/g, '"');
  if (normalized !== query) {
    add("error", "curly_quotes", "Curly quotes were replaced with straight quotes.");
  }

  // Quoted phrases are literal, so operators are only checked outside them.
  const outside = normalized.replace(/"[^"]*"/g, (m) => "_".repeat(m.length));
  if ((normalized.match(/"/g) ?? []).length % 2) {
    add("error", "unbalanced_quotes", "A quoted phrase is missing its closing quote.");
  }

  let depth = 0;
  let unbalanced = false;
  for (const ch of outside) {
    if (ch === "(") depth += 1;
    if (ch === ")") depth -= 1;
    if (depth < 0) unbalanced = true;
  }
  if (depth !== 0 || unbalanced) {
    add("error", "unbalanced_parentheses", "Parentheses aren't balanced.");
  }

  const lowercase = outside.match(/\b(and|or|not)\b/gi)?.filter((w) => w !== w.toUpperCase()) ?? [];
  if (lowercase.length) {
    add(
      "error",
      "lowercase_operator",
      `Operators must be uppercase. Found: ${[...new Set(lowercase)].join(", ")}. They were uppercased.`,
    );
    const chars = [...normalized];
    for (const m of outside.matchAll(/\b(and|or|not)\b/gi)) {
      for (let i = 0; i < m[0].length; i += 1) {
        chars[m.index + i] = chars[m.index + i].toUpperCase();
      }
    }
    normalized = chars.join("");
  }

  if (/(^|[\s(])[+-]\S/.test(outside)) {
    add("error", "plus_minus_operator", "LinkedIn doesn't officially support + or - operators. Use AND or NOT.");
  }
  if (outside.includes("*")) {
    add("error", "wildcard", "Wildcards aren't supported. List the variations with OR.");
  }

  const operators = outside.match(/\b(AND|OR|NOT)\b/gi)?.length ?? 0;
  if (operators > 15) {
    add("warning", "too_many_operators", `Found ${operators} operators; LinkedIn's article says about 15 are supported.`);
  }
  if (/\b(AND|OR|NOT)\s*\)|\(\s*(AND|OR)\b|^\s*(AND|OR)\b|\b(AND|OR|NOT)\s*$/i.test(outside)) {
    add("error", "dangling_operator", "An operator is missing a term on one side.");
  }

  return {
    valid: !issues.some((i) => i.severity === "error"),
    normalized_query: normalized,
    operator_count: operators,
    issues,
    rules: "Use uppercase AND, OR and NOT, straight quotes for phrases and parentheses for grouping. Precedence is quotes, parentheses, NOT, AND, OR. Spaces between terms imply AND.",
    limitations: "This checks syntax only. Boolean works in the company, title and keyword fields, so confirm the result in a live search.",
    source_url: "https://www.linkedin.com/help/sales-navigator/answer/a168061",
  };
}
