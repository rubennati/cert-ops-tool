# Changelog

All notable changes to this project are documented in this file.

Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Versioning: [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.1] — 2026-05-04

### Added

- Startup log printed to container stdout on every start — shows CF_Token status, ACME email, server, key length, and timezone so `docker compose logs` gives immediate confirmation the container is configured correctly.

## [0.2.0] — 2026-05-04

### Changed

- Scripts (`issue.sh`, `renew.sh`, `convert-to-pfx.sh`) and the entrypoint wrapper are now baked into a versioned Docker image published to GHCR (`ghcr.io/rubennati/cert-ops-tool`). The compose file pulls the image directly — no local script bind-mounts required.
- Default `APP_TAG` in `.env.example` updated to `v0.2.0`.

### Removed

- Local `config/` and `scripts/` bind-mounts from the container (scripts are now part of the image).

## [0.1.0] — 2026-04-16

Initial public release.

### Added

- Docker Compose setup running `neilpang/acme.sh` with `crond` for automatic renewal
- Cloudflare API token loaded from a Docker Secret (`.secrets/cf_token.txt`) via entrypoint wrapper
- Interactive `scripts/wizard.sh` for issuing certificates (single domain or wildcard)
- Direct `scripts/issue.sh` and `scripts/renew.sh` for scripted automation
- `scripts/convert-to-pfx.sh` for Windows / IIS / Synology PFX import
- Standard output layout: `volumes/output/<domain>/{cert,fullchain,privkey,ca}.pem`
- Documentation: README, CONFIG.md, SECURITY.md, CONTRIBUTING.md, CODE_OF_CONDUCT.md
- PolyForm Noncommercial 1.0.0 license

### Known limitations

- Only Cloudflare DNS-01 challenge is wired in by default (other providers documented in CONFIG.md, require manual adaptation of `scripts/issue.sh`)
- No automatic distribution to target devices yet — output files must be transferred manually (SCP / rsync / etc.)
- No built-in expiry alerting

[Unreleased]: https://github.com/rubennati/cert-ops-tool/compare/v0.2.1...HEAD
[0.2.1]: https://github.com/rubennati/cert-ops-tool/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/rubennati/cert-ops-tool/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/rubennati/cert-ops-tool/releases/tag/v0.1.0
