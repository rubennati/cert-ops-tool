# Roadmap

Things that should happen but have not. Released changes are in
[CHANGELOG.md](CHANGELOG.md); the short feature list is in
[README.md](README.md#roadmap). This file is for items that need a decision
before anyone can work on them — the point of an entry here is to state the
problem and the options, not to pick one in advance.

---

## Open decision: keep the operator's identity out of the repository

**Status:** to research and decide. Nothing implemented.

### Why

The repository is public and forkable, and so is the site built from it. The
legal notice and the privacy page carry the operator's real name, postal
address, email address, company register entry and VAT number; the deployment
carries the domain. All of it is plain text in the working tree today:

| File | What it holds |
|---|---|
| `docs/legal.md` | name, registered company, postal address, email, FN, UID, and the domain in a licence link |
| `docs/privacy.md` | name and postal address of the controller |
| `docs/.vitepress/config.ts` | domain (sitemap hostname, canonical URLs) |
| `docs/.vitepress/theme/SiteFooter.vue` | domain (issue-report links) |
| `docs/public/CNAME`, `docs/public/robots.txt` | domain |

Two things follow. A fork carries the operator's identity by default — and a
fork that republishes unchanged publishes a disclosure naming someone who did
not publish it, which is worse than having none. And the email address in
particular sits in a public repository as scrapable plain text.

### What this is *not*

It is not about hiding the disclosure from visitors. § 5 ECG requires it to be
publicly readable on the live site, so whatever is chosen must still render the
real values on `cert-ops.rubennati.at`. The goal is narrower:

1. a fork should not inherit the operator's identity, and
2. the values should not sit in the repository as plain text.

**Honest constraint to weigh first:** the data is already in the git history
(commit `3f9308d`, merged in #1), and the live site publishes it anyway. Any
mechanism short of a history rewrite leaves the old copies reachable, and a
scraper can read the rendered page regardless. So the realistic benefit is
mostly (1) — fork hygiene — and only partly (2). Decide whether that is worth a
build-time decryption step before choosing one.

### Options to evaluate

- **SOPS + age.** Encrypted `legal.enc.yaml` (or similar) in the repository,
  decrypted in the Pages workflow with an age key held in GitHub Actions
  Secrets, values rendered into the pages at build time. Repository stays
  public; cleartext exists only inside CI. A fork gets a file it cannot
  decrypt — arguably the correct failure, because it forces the forker to
  supply their own values.
- **GitHub Actions Secrets alone.** Keep the values out of the repository
  entirely and inject them at build time. No crypto, fewer moving parts, but
  the values are then invisible to a local `npm run docs:dev`, so a documented
  placeholder fallback is required.
- **Private repository or submodule** holding the legal pages, pulled at
  deploy. Conceptually clean, most moving parts, and it splits the site's
  content across two places.
- **Placeholders by default plus a local, gitignored override file.** No crypto
  at all and the friendliest to forks, but nothing prevents a contributor from
  committing real values by accident.
- **A "make it yours" reset script** (`scripts/…`) that replaces identity,
  domain (CNAME, canonical, sitemap hostname), footer links and the legal and
  privacy pages with placeholders. Useful *in addition to* whichever of the
  above is chosen, and the thing a forker actually needs.

### Questions to answer before deciding

- Must `npm run docs:dev` work offline, without secrets, for anyone?
- What happens on a pull request from a fork? Secrets are not available there —
  the docs build must not fail, so placeholders have to be a valid build state.
- Is rewriting the git history in scope, or is "no new plaintext from here on"
  the goal?
- Who else must be able to decrypt, if anyone? A single age key held by one
  person is also a single point of failure.
- Does encryption in the repository measurably reduce scraping, given the live
  site is public and indexed? If the honest answer is "barely", the placeholder
  route wins on simplicity.

### Done when

A decision is written down (here or as an ADR), implemented in the docs build,
and `CONTRIBUTING.md` and `README.md` state plainly what a forker has to
replace before publishing.
