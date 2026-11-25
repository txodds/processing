# Skills

[← Back to repo README](../README.md)

Claude Code skills shared across the team.

| Skill | What it does |
|---|---|
| [`alps-market-explain`](./alps-market-explain/SKILL.md) | Explains one Alps market from [alps-market-catalogue](https://github.com/txodds/alps-market-catalogue): what it is, how it settles, its TX config and whether the robot maps it. |

## Adding a skill

Each skill lives in its own folder here, with a `SKILL.md` at its root:

```
skills/
  <skill-name>/
    SKILL.md           # frontmatter (name, description) + instructions
    <skill-name>.sh    # optional helper scripts the skill calls
    reference.md       # optional extra docs the skill loads on demand
```

`SKILL.md` starts with YAML frontmatter. The `description` is what Claude uses to decide when to load the skill, so say what it does and when to use it:

```markdown
---
name: <skill-name>
description: One or two sentences on what this does and when Claude should use it.
---

Instructions for Claude...
```

### When to add a script

Prefer plain instructions in `SKILL.md`. Add a script only when it saves Claude real work, and say why in the skill. Good reasons:

- **Keep Claude's context small.** Filter large files or API responses down to what the question needs, so Claude never reads the whole thing.
- **Fewer tool calls.** Join several fetches into one call, so one permission prompt and one turn instead of several.
- **Repeatable results.** Fix matching or parsing rules in code instead of Claude rewriting them each run.

Call the script as `${CLAUDE_SKILL_DIR}/<script>` so it works wherever the skill is installed. [`alps-market-explain`](./alps-market-explain/SKILL.md#why-a-script) is an example.

See the [Claude Code skills docs](https://docs.claude.com/en/docs/claude-code/skills) for the full format.

## Using a skill

Symlink the skill folder into your personal or project skills directory so updates arrive with a `git pull`. From the repo root:

```sh
# available in every project
ln -s "$PWD/skills/<skill-name>" ~/.claude/skills/<skill-name>

# or only within one project
ln -s "$PWD/skills/<skill-name>" /path/to/project/.claude/skills/<skill-name>
```

## Publishing a skill to a marketplace

Symlinking needs a clone of this repo and a terminal. To let anyone at TXOdds install a skill from Claude under their company login, with no GitHub account, publish it as a plugin in a marketplace synced to the TXOdds Claude organisation. Synced marketplaces show up in `/plugin` in Claude Code and in the Claude desktop app's plugin directory.

Where it goes depends on what the skill depends on, following [Sharing Claude Plugins: Quickstart](https://txodds.atlassian.net/wiki/spaces/BIGDATA/pages/5552537609/Sharing+Claude+Plugins+Quickstart):

- **Depends on one repo's code or data:** a marketplace in that repo. For example, `alps-market-explain` reads `alps-market-catalogue`, so it would go in a marketplace there, the way `dq-web-visualisation` hosts its own plugin.
- **Depends on no single repo:** a pull request to [txodds/shared-claude-plugins](https://github.com/txodds/shared-claude-plugins), whose README covers the steps and owners.

Keep developing a skill here and publish it once it is stable. Plugin skills are namespaced, so `/<skill-name>` becomes `/<plugin>:<skill-name>`.

To see which marketplaces you have added, and the TXOdds ones you have not:

```sh
claude plugin marketplace list
```
