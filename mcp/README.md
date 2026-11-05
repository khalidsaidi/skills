# Sales Navigator notes service

A read-only [MCP](https://modelcontextprotocol.io) server over the [`linkedin-sales-navigator`](../skills/linkedin-sales-navigator) skill's notes. It's independent and isn't affiliated with or endorsed by LinkedIn. It doesn't access LinkedIn or any account.

| Tool | Does |
| --- | --- |
| `search_notes` | Searches the notes and returns matches with source links |
| `get_note` | Returns the complete note for an article |
| `list_topics` | Lists the topics and how many notes each has |
| `check_boolean_query` | Checks a Boolean search against LinkedIn's documented syntax and returns a corrected query |

## Develop

```bash
npm install
npm test
```

`npm run notes` builds `lib/notes.json` from the skill's notes. Run it before deploying.

See the [privacy policy](PRIVACY.md).
