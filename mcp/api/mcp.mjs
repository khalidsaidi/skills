import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StreamableHTTPServerTransport } from "@modelcontextprotocol/sdk/server/streamableHttp.js";
import { z } from "zod";
import { checkBooleanQuery, getNote, listTopics, searchNotes } from "../lib/tools.mjs";

const readOnly = { readOnlyHint: true, destructiveHint: false, openWorldHint: false };
const result = (data) => ({
  content: [{ type: "text", text: JSON.stringify(data) }],
  structuredContent: data,
});

function createServer() {
  const server = new McpServer(
    { name: "linkedin-sales-navigator", version: "1.0.0" },
    {
      instructions:
        "Independent, dated notes on LinkedIn Sales Navigator's public help articles, not affiliated with LinkedIn. This server doesn't access LinkedIn or any account. Cite each note's source_url and check current documentation for details that may have changed.",
    },
  );

  const noteSummary = z.object({
    article_id: z.string(),
    title: z.string(),
    topic: z.string(),
    source_url: z.string().nullable(),
    snippet: z.string(),
  });

  server.registerTool(
    "search_notes",
    {
      title: "Search Sales Navigator notes",
      description:
        "Use when someone asks how a Sales Navigator feature, plan, integration, admin setting or billing process works. Searches paraphrased notes on the public help articles and returns matches with source links.",
      inputSchema: {
        query: z.string().min(1).max(200).describe("Keywords, an article title or an article ID"),
        limit: z.number().int().min(1).max(20).default(5).describe("Maximum results to return"),
      },
      outputSchema: { total_matches: z.number(), results: z.array(noteSummary) },
      annotations: readOnly,
    },
    async ({ query, limit }) => result(searchNotes(query, limit)),
  );

  server.registerTool(
    "get_note",
    {
      title: "Read a Sales Navigator note",
      description:
        "Use after search_notes to read the complete note for one article before answering. Takes an article ID such as a168061.",
      inputSchema: {
        article_id: z.string().regex(/^[aA]\d+$/).describe("Article ID, such as a168061"),
      },
      outputSchema: {
        article_id: z.string(),
        title: z.string(),
        topic: z.string(),
        source_url: z.string().nullable(),
        note: z.string(),
      },
      annotations: readOnly,
    },
    async ({ article_id }) => {
      const note = getNote(article_id);
      if (!note) {
        return {
          isError: true,
          content: [{ type: "text", text: `No note found for ${article_id}. Use search_notes to find an article ID.` }],
        };
      }
      return result(note);
    },
  );

  server.registerTool(
    "list_topics",
    {
      title: "List Sales Navigator topics",
      description:
        "Use when someone wants to see what the notes cover. Returns each topic and its number of notes.",
      inputSchema: {},
      outputSchema: {
        total_notes: z.number(),
        topics: z.array(z.object({ topic: z.string(), note_count: z.number() })),
      },
      annotations: readOnly,
    },
    async () => result(listTopics()),
  );

  server.registerTool(
    "check_boolean_query",
    {
      title: "Check a Sales Navigator Boolean query",
      description:
        "Use before someone runs a Boolean search in Sales Navigator. Checks operators, quotes and parentheses against LinkedIn's documented syntax, and returns any issues and a corrected query.",
      inputSchema: {
        query: z.string().min(1).max(2000).describe("The Boolean search text to check"),
      },
      outputSchema: {
        valid: z.boolean(),
        normalized_query: z.string(),
        operator_count: z.number(),
        issues: z.array(z.object({ severity: z.string(), code: z.string(), message: z.string() })),
        rules: z.string(),
        limitations: z.string(),
        source_url: z.string(),
      },
      annotations: readOnly,
    },
    async ({ query }) => result(checkBooleanQuery(query)),
  );

  return server;
}

export default async function handler(req, res) {
  if (req.method !== "POST") {
    res.setHeader("Allow", "POST");
    res.status(405).json({
      jsonrpc: "2.0",
      error: { code: -32000, message: "Method not allowed. This server is stateless, so send POST requests." },
      id: null,
    });
    return;
  }
  const server = createServer();
  const transport = new StreamableHTTPServerTransport({
    sessionIdGenerator: undefined,
    enableJsonResponse: true,
  });
  res.on("close", () => {
    transport.close();
    server.close();
  });
  await server.connect(transport);
  await transport.handleRequest(req, res, req.body);
}
