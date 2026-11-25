---
name: alps-market-explain
description: Explain a single Alps (Lacerta) market and its configuration from the txodds/alps-market-catalogue, covering what it is, how it settles, its lines and selections, lifecycle status, TX config (SOT, display name, period, grades, in-running, SGP) and whether the AHCRobots Alps robot handles it on ng-dev / ng-prod. Use when someone asks "what is market X", "how does X settle", "is X mapped", or gives an Alps market type ID such as MATCH_1X2 or CR_MATCH_1X2.
---

# Explain an Alps market

Explains one market from [txodds/alps-market-catalogue](https://github.com/txodds/alps-market-catalogue), the JSON copy of Lacerta's [ALPS-API Market Catalogue](https://github.com/LacertaSports/ALPS-API/tree/main/Market-Catalogue). Field meanings live in that repo's README and `schema/market-catalogue.schema.json`; read them when a field is unclear rather than guessing.

## 1. Look the market up

```sh
${CLAUDE_SKILL_DIR}/market-lookup.sh <market type ID or name> [sport]
```

Always use the script; do not fetch or read the catalogue files directly (see [Why a script](#why-a-script)). It reads `main` of the catalogue repo through `gh`, which needs to be authenticated with access to it. Each match is one JSON object: the catalogue market plus `sport`, `sourceDoc` (upstream Markdown) and `robotMapping` (per market type ID, whether `ng-dev` / `ng-prod` of AHCRobots has a handler, as of `handlersGeneratedAt`).

- Several matches: list them (sport, name, market type IDs) and ask which one, unless the question already picks one out.
- No match: say so and try a shorter name fragment or the other sports before giving up. Do not invent a market.

## 2. Explain it

Answer in this order, using only what the JSON says. Where a field is `null` or empty, say it is not set; never fill it in with a plausible default.

1. **What it is.** Name, sport, market type ID(s), category, and the `description` in plain words. Mention `categoryNotes` when present, since they apply to every market in that category.
2. **How it settles.** Which outcome wins each selection, the period it covers, and anything in `notes` or `bounds` (e.g. what counts, push/void rules, extra time excluded). Work through one concrete scoreline or game state to show a winning and a losing selection.
3. **Lines and selections.** Single or multiple lines (`canHaveMultipleLines`, `fixedNumberOfLines`), selections per line, and the `examples` / `selectionList` rows as a small table. Multi-instance markets (`isMultiInstance`, `isMultiInstanceQualifier`): explain what one instance is (per player, per batsman, etc.). Two market type IDs on one market are the two team variants, not two instances.
4. **Metadata.** The `metadata.marketMetadata` / `selectionMetadata` fields a consumer reads to place a price, with their examples.
5. **Lifecycle.** `status.state`, and the `obsoleteNotice` if obsolete.
6. **TX config.** From `txMetadata`: SOT, display name, period, market params, grades offered, in-running, SGP availability, market status, tags, links (Jira tickets as links) and notes. `txMetadata: null` means TX has no data for the market yet. The period uses Fusion's MarketPeriod syntax, so read it literally (e.g. a `between=` window).
7. **Robot mapping.** From `robotMapping`: mapped on both branches, dev only (not yet released), or unmapped, as of `handlersGeneratedAt`. `null` means the sport has no Alps robot handler map (cricket).
8. **History.** `txTracking.firstSeen`, `lastChanged`, and any `modified` / `removed` changelog entries worth knowing.

Finish with a **sanity check**: does the TX config agree with the catalogue? Flag mismatches, for example a period that does not match the market name, an SOT whose name implies a different market, `inRunning` set on a pre-match only market, a market TX marks released that the robot does not map, or an obsolete/deprecated market that is still mapped.

Link the upstream doc (`sourceDoc`) and any Jira tickets, always as Markdown links.

## Why a script

`market-lookup.sh` exists to keep Claude's context small and the lookup repeatable, not because the lookup is hard:

- **Context.** The catalogue files are large (soccer is around 1MB). Reading one, or even a loosely filtered `jq` result, fills the context window with markets the question is not about, which costs tokens and crowds out the conversation. The script returns only the matching markets.
- **One call, not several.** The market and its robot mapping live in two files. The script joins them, so Claude makes one tool call (one permission prompt) instead of fetching, filtering and cross-referencing over several turns.
- **Same answer every time.** Matching rules are fixed in code rather than rewritten by Claude per run: an exact market type ID wins over partial matches, and the `\-` escapes kept from Lacerta's Markdown are ignored when matching names.
