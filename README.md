# processing

Shared team tooling: Claude Code skills, helper scripts and Postman collections that anyone on the team can use, review and improve.

## Layout

| Directory | What goes in it |
|---|---|
| [`skills/`](./skills/README.md) | Claude Code skills, one folder per skill |
| [`scripts/`](./scripts/README.md) | Standalone helper scripts (shell, Python, etc.) |
| [`postman/`](./postman/README.md) | Postman collections and environments |

Each directory's README covers its conventions and how to use what's in it.

## Installing skills

Two ways to get the skills in this repo into Claude:

- **Symlink** a skill from your clone, for developing and trying skills out: see [Using a skill](./skills/README.md#using-a-skill).
- **Install from a marketplace** with your company login, no clone or GitHub account needed, once a skill is published: see [Publishing a skill to a marketplace](./skills/README.md#publishing-a-skill-to-a-marketplace).

## Contributing

- Never commit credentials, tokens, `.env` files or customer data.
- Docs refer to the setting, file or constant that holds a value rather than repeating the value, so there is only one place to maintain.
- Open a PR for changes so the team can review.
