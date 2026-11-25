# Postman

[← Back to repo README](../README.md)

Collections and environments for TxODDS APIs, exported from Postman so they can be reviewed in PRs and imported by anyone on the team.

```
postman/
  collections/    # one collection per service, e.g. fixture-api
  environments/   # one environment per target, e.g. dev, test, prod
```

- Name files after the service or environment they target.
- Environments hold URLs and non-secret variables only. Leave secret values (tokens, passwords) blank or mark them as secret in Postman, and fill them in locally.
- Re-export and commit after changing a collection in Postman so the repo stays the source of truth.
