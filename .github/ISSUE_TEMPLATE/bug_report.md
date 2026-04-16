---
name: Bug report
about: Something isn't working as expected
title: ''
labels: bug
assignees: ''
---

## What happened

A clear, concise description of the bug.

## Expected behavior

What you expected to happen instead.

## Reproduction steps

1. ...
2. ...
3. ...

## Environment

- cert-ops-tool version (tag or commit): 
- Docker / Compose version: 
- Host OS + arch: 
- ACME server used: letsencrypt / zerossl / buypass
- DNS provider: 

## Logs

```
Paste relevant output from:
  docker compose logs --tail 100 acme-certs
Redact any API tokens, domain names you don't want public,
and the contents of fullchain.pem / privkey.pem / cf_token.txt.
```

## Additional context

Anything else that might help — screenshots, links to related issues, workarounds you tried.
