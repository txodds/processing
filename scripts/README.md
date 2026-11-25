# Scripts

[← Back to repo README](../README.md)

Standalone helper scripts shared across the team.

## Adding a script

Put each script directly in this folder (or a subfolder if it needs supporting files). Each script should:

- Print usage with `-h`/`--help`
- Read secrets and tokens from environment variables, never hard-coded values
- Be executable (`chmod +x`) with a shebang line
