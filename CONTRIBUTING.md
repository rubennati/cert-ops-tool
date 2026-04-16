# Contributing to cert-ops-tool

Thanks for considering a contribution. This project is small and opinionated, but improvements, bug fixes, and discussion are welcome.

## Before you start

- **License**: contributions are accepted under the project's [PolyForm Noncommercial 1.0.0 license](LICENSE). By submitting a contribution you agree that it can be distributed under those terms.
- **Code of Conduct**: see [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md). Be respectful.
- **Security issues**: please do not open public issues for security bugs. See [SECURITY.md](SECURITY.md).

## What's welcome

- Bug reports with clear reproduction steps
- Support for additional DNS providers (Hetzner, deSEC, DigitalOcean, Route53, etc.) — either as new script variants or as documentation of how to adapt `scripts/issue.sh`
- Improvements to the wizard UX (prompt flow, defaults, validation)
- Documentation fixes and clarifications
- Additional import recipes for devices not yet covered (mail servers, specific router firmwares, Proxmox hosts, etc.)

## What's out of scope (for now)

- Provider-specific integrations that ship credentials in cleartext
- Wrappers around different ACME clients (`certbot`, `lego`, etc.) — this project is explicitly built on `acme.sh`
- Large architectural changes without prior discussion in an issue

If you have an idea for a larger change, please open an issue first to discuss the direction before writing code.

## Workflow

1. **Fork** the repository
2. **Create a branch** off `main` with a descriptive name: `fix-wizard-empty-san`, `add-hetzner-dns`, `docs-synology-import`
3. **Make your changes** — keep them focused on a single topic
4. **Test** — at minimum:
   - `docker compose up -d` starts without errors
   - The wizard runs through interactively
   - An `issue` command produces `fullchain.pem` and `privkey.pem`
   - A `renew` command works (can be simulated against Let's Encrypt staging)
5. **Open a Pull Request** against `main`

## Commit messages

- Use short, imperative subjects: `fix wizard validation for empty SAN`, `add Hetzner DNS provider`, `docs: add OPNsense import recipe`
- Keep unrelated changes in separate commits
- Reference issues with `Fixes #N` or `Refs #N` in the commit body when applicable

## Pull request expectations

- Describe **what** changed and **why**
- List manual test steps you ran
- Update `CHANGELOG.md` under the `## [Unreleased]` section
- Update `README.md` / `CONFIG.md` if the change affects usage or configuration

## Code style

- Shell scripts: POSIX `sh` where possible, `set -eu` at the top, clear comments for non-obvious parts
- Markdown: one sentence per line for easier diffs is preferred but not required
- YAML: 2-space indent, no trailing whitespace

## Releases

Maintained by the project owner. Version bumps follow [Semantic Versioning](https://semver.org/):

- **MAJOR** — breaking changes to script interface or compose structure
- **MINOR** — new functionality, backwards-compatible
- **PATCH** — bug fixes, docs, security fixes

Each release updates `CHANGELOG.md` and creates a Git tag (`v0.1.0`, `v0.2.0`, ...).

## Questions?

Open a [discussion](https://github.com/rubennati/cert-ops-tool/discussions) or file an issue with the `question` label.
