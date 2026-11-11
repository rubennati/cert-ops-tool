# Changelog

## [0.3.0] — 2026-11-11

Security release. Images up to and including `0.2.1` are built on a base from November 2025 and carry known vulnerabilities in OpenSSL, curl, OpenSSH, BIND tools and socat (Trivy: 9 critical, 91 high). Upgrade by setting `APP_TAG=0.3.0`, then `docker compose pull && docker compose up -d`.

### Security

- Base image updated from `neilpang/acme.sh:3.1.2` (Alpine 3.22) to `3.1.6` (Alpine 3.23), pinned by digest, with Alpine security updates applied at build time. The rebuilt image scans clean.
- `issue.sh`, `renew.sh` and `convert-to-pfx.sh` run under `umask 077`: private keys and PFX files are never group- or world-readable, not even between creation and `chmod`.
- `issue.sh`, `renew.sh`, `convert-to-pfx.sh` and the wizard reject domain values that are not host names (`/`, `..`, leading dot), since the value becomes a path under `/output`.
- `convert-to-pfx.sh` reads the password from an interactive prompt or `PFX_PASSWORD` and hands it to OpenSSL through the environment, so it no longer appears in the process list.
- Workflow actions are pinned to commit SHAs; Dependabot watches the base image, the actions and the docs dependencies.
- New CI workflow: ShellCheck, image build and a Trivy scan on every pull request, plus a weekly scan of the published image.

### Changed

- Bundled `acme.sh` is now 3.1.6. Renewal follows ACME Renewal Information (ARI) by default: the cron job runs every six hours and renews inside the window the CA suggests. Set `NO_ARI=1` to disable. Upstream removed the `dns_hetzner` and `dns_linode` (v3) DNS hooks in favour of `dns_hetznercloud` and `dns_linode_v4` — relevant only if you adapted `issue.sh` to one of them.

### Deprecated

- Passing the PFX password as the second argument to `convert-to-pfx.sh`. It still works and prints a warning.

## [0.2.1] — 2026-05-04

### Added

- Startup log printed to container stdout on every start — shows CF_Token status, ACME email, server, key length, and timezone so `docker compose logs` gives immediate confirmation the container is configured correctly.

## [0.2.0] — 2026-05-04

### Changed

- Scripts (`issue.sh`, `renew.sh`, `convert-to-pfx.sh`) and the entrypoint wrapper are now baked into a versioned Docker image published to GHCR (`ghcr.io/rubennati/cert-ops-tool`). The compose file pulls the image directly — no local script bind-mounts required.
- Default `APP_TAG` in `.env.example` updated to `0.2.0`.

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

### Known limitations (0.1.0)

- Only Cloudflare DNS-01 is wired in by default (other providers documented in [Configuration](/reference/configuration), require manual adaptation of `scripts/issue.sh`)
- No automatic distribution to target devices — output files must be transferred manually
- No built-in expiry alerting

[0.3.0]: https://github.com/rubennati/cert-ops-tool/compare/v0.2.1...v0.3.0
[0.2.1]: https://github.com/rubennati/cert-ops-tool/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/rubennati/cert-ops-tool/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/rubennati/cert-ops-tool/releases/tag/v0.1.0
