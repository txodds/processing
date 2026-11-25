# processing

Shared team tooling: Claude Code skills, helper scripts and Postman collections that anyone on the team can use, review and improve.

## Layout

| Directory | What goes in it |
|---|---|
| [`skills/`](./skills/README.md) | Claude Code skills, one folder per skill |
| [`scripts/`](./scripts/README.md) | Standalone helper scripts (shell, Python, etc.) |
| [`postman/`](./postman/README.md) | Postman collections and environments |

Each directory's README covers its conventions and how to use what's in it.

## Contributing

- Never commit credentials, tokens, `.env` files or customer data.
- Docs refer to the setting, file or constant that holds a value rather than repeating the value, so there is only one place to maintain.
- Open a PR for changes so the team can review.
