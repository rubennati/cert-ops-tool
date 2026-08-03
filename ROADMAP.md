# Roadmap

Things that should happen but have not. Released changes are in
[CHANGELOG.md](CHANGELOG.md); the short feature list is in
[README.md](README.md#roadmap). This file is for items that need a decision
before anyone can work on them — an entry states the problem, the direction
taken, and what is still open.

---

## Open decision: keep the operator's identity out of the repository

**Status:** direction decided, nothing implemented.

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
mostly (1) — fork hygiene — and only partly (2). The step below is cheap enough
to be worth it anyway, but it should not be mistaken for making the data
private.

### Direction

Encrypt whole files, not fields — but only the two that actually carry personal
data, and always alongside a placeholder version so the repository still builds
without a key.

**Encrypt:** `docs/legal.md` and `docs/privacy.md`. Each is committed twice: an
encrypted blob (`age`, or SOPS in binary mode) holding the real page, and a
cleartext **placeholder** of the same page with the identity fields blanked out
and a line saying they must be filled in before publishing. The Pages workflow
decrypts the blob with a key from GitHub Actions Secrets, overwrites the
placeholder in the checkout, and builds. Plain text then exists in exactly two
places: the encrypted blob and the CI runner.

That gives all three properties at once — the live site renders the real
disclosure, the repository holds no readable identity, and a fork gets a
template that asks to be filled in instead of someone else's disclosure.

**Leave alone:** `docs/.vitepress/config.ts`, `docs/.vitepress/theme/SiteFooter.vue`,
`docs/public/CNAME` and `docs/public/robots.txt`. They hold the domain and
nothing else, and:

- `config.ts` and `SiteFooter.vue` are build machinery. Encrypt them and nobody
  can build or preview the site without the key — including the operator.
- `CNAME` has to end up as plain text in the published output for GitHub Pages
  to serve the custom domain at all.
- The domain is not personal data in the sense that matters here: it is in
  public DNS, in the `CNAME` record, in Certificate Transparency logs, and in
  every link to the site. Encrypting it costs the local build and buys nothing.

If the goal for those files is *fork convenience* rather than privacy — one
place to change the domain instead of four — that is a small refactor into a
single config value, not a crypto problem. Worth doing, separately.

**Tooling, to settle when implementing:** plain `age` is probably enough for
whole-file blobs (`age -R recipients.txt -o docs/legal.md.age docs/legal.md`,
`age -d -i key.txt` in CI). SOPS earns its keep on *partially* encrypted
structured files, which this is not; its binary mode would work too and brings
`.sops.yaml` rules along. Either way the key lives in Actions Secrets and never
in the repository.

### Answered

- **Do pull requests from forks break?** No. `.github/workflows/docs.yml` runs
  on push to `main` and `workflow_dispatch` only — there is no `pull_request`
  trigger, so a fork PR never needs the key. If a PR preview build is added
  later, the committed placeholder keeps it building.
- **Does local development break?** No, that is what the placeholder is for.
  `npm run docs:dev` builds the placeholder pages, offline, without a key.

### Still open

- **Key custody.** A single age key is a single point of failure — losing it
  means the pages can never be decrypted again. Decide on a second recipient
  or an offline backup as part of the implementation, not after it.
- **The git history.** Rewrite it, or accept that `3f9308d` keeps the old
  plaintext reachable and treat this as "no new plaintext from here on"?
- **Placeholder wording.** It has to be obviously a placeholder — a disclosure
  that looks filled in but is not is worse than an empty one.
- **Fork instructions.** `CONTRIBUTING.md` and `README.md` need a short section
  saying what to replace and that the encrypted blobs are not theirs to keep.

### Done when

A decision is written down (here or as an ADR), implemented in the docs build,
and `CONTRIBUTING.md` and `README.md` state plainly what a forker has to
replace before publishing.
