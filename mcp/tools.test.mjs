import assert from "node:assert/strict";
import { test } from "node:test";
import { checkBooleanQuery, getNote, listTopics, searchNotes } from "./lib/tools.mjs";

test("every note is available, grouped by topic", () => {
  const { total_notes, topics } = listTopics();
  assert.equal(total_notes, 421);
  assert.equal(topics.reduce((n, t) => n + t.note_count, 0), 421);
});

test("search finds a note by title, keyword and ID", () => {
  assert.equal(searchNotes("Boolean search syntax").results[0].article_id, "a168061");
  assert.ok(searchNotes("InMail credits").results.some((r) => r.article_id === "a101030"));
  assert.equal(searchNotes("a168061").results[0].article_id, "a168061");
  assert.equal(searchNotes("zzzzqqqq").total_matches, 0);
  assert.equal(searchNotes("SCIM", 2).results.length, 2);
});

test("get_note returns the note with its source, and null when missing", () => {
  const note = getNote("A168061");
  assert.equal(note.source_url, "https://www.linkedin.com/help/sales-navigator/answer/a168061");
  assert.match(note.note, /Uppercase AND\/OR\/NOT/);
  assert.doesNotMatch(note.note, /^Source:/m);
  assert.equal(getNote("a1"), null);
});

const codes = (q) => checkBooleanQuery(q).issues.map((i) => i.code);

test("a correct query passes", () => {
  const r = checkBooleanQuery('("vice president" OR VP) AND finance NOT intern');
  assert.equal(r.valid, true);
  assert.deepEqual(r.issues, []);
  assert.equal(r.operator_count, 3);
});

test("operators inside quotes are literal", () => {
  assert.equal(checkBooleanQuery('"research and development" AND manager').valid, true);
});

test("syntax problems are reported", () => {
  assert.deepEqual(codes("(VP OR director"), ["unbalanced_parentheses"]);
  assert.deepEqual(codes('"vice president'), ["unbalanced_quotes"]);
  assert.deepEqual(codes("engineer*"), ["wildcard"]);
  assert.deepEqual(codes("+manager -intern"), ["plus_minus_operator"]);
  assert.deepEqual(codes("manager AND"), ["dangling_operator"]);
  assert.deepEqual(codes(")VP("), ["unbalanced_parentheses"]);
});

test("lowercase operators and curly quotes are corrected", () => {
  const r = checkBooleanQuery("“vice president” and finance or sales");
  assert.equal(r.valid, false);
  assert.equal(r.normalized_query, '"vice president" AND finance OR sales');
  assert.deepEqual(r.issues.map((i) => i.code), ["curly_quotes", "lowercase_operator"]);
});

test("more than about 15 operators is a warning, not an error", () => {
  const r = checkBooleanQuery(Array(18).fill("a").join(" OR "));
  assert.equal(r.valid, true);
  assert.deepEqual(r.issues.map((i) => i.code), ["too_many_operators"]);
});
