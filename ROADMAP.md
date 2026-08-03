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

Same shape as the sibling project's plan (`secure-docker-blueprint`, ROADMAP —
"one data module rather than encrypted pages"), so both sites are maintained
the same way.

**One values module, not five encrypted files.** The identity fields —
operator, registered company, address, email, FN, UID — move out of the prose
into a single module under `docs/.vitepress/data/`. `site.ts` is committed and
holds placeholders; `site.local.ts` is the decrypted real thing, gitignored,
and wins when present. `legal.md` and `privacy.md` keep their prose in the
repository and interpolate the values (VitePress compiles markdown as a Vue
SFC, so a `<script setup>` block can import the module); `config.ts` and
`SiteFooter.vue` import the same module.

Why this beats encrypting the two markdown pages whole: decrypting over a
*committed* placeholder invites a thoughtless `git add` that puts the real
values back into a history that keeps them. A gitignored file cannot be added
by accident. One file to encrypt, one import to resolve, and no state in the
working tree that a fork could mistake for its own. A pre-commit guard is then
a belt on top of braces rather than the only thing preventing a permanent
mistake.

**Empty versus neutral placeholders.** Name, address and email go *empty* — a
reader should see that a field is blank. Values the build cannot do without
get a neutral stand-in instead: the site URL feeds canonical tags and the
sitemap, so `example.com` keeps a fork building where an empty string would
produce a broken build rather than an obvious gap.

**Leave in cleartext:** `docs/public/CNAME`, `docs/public/robots.txt`, and the
domain wherever the build needs it literally.

- `CNAME` has to be plain text in the published output for GitHub Pages to
  serve the custom domain at all.
- The domain is not personal data in the sense that matters here: it is in
  public DNS, in the `CNAME` record, in Certificate Transparency logs, and in
  every link to the site. Encrypting it would cost the local build and buy
  nothing. Routing it through the module is still worth it — but for fork
  convenience, one place to change instead of four, not for privacy.

**Tooling.** `age`, whole-file, ASCII-armoured, blob in `secrets/`. SOPS earns
its place when single fields inside a YAML stay readable, which is not the case
here — whole file, so it would be one layer over the same age.

The key reaches `age` on a file descriptor, never through the filesystem:

```bash
age -d -i <(op read "op://Private/age-signing-key/notesPlain") \
    -o docs/.vitepress/data/site.local.ts secrets/site.age
```

The runner needs the same care for the opposite reason — writing the key to a
temporary file and deleting it afterwards leaves a window, however short — so
`age -d -i <(printf '%s' "$AGE_KEY")` there too, with `AGE_KEY` from a GitHub
Actions secret.

### Answered

- **Do pull requests from forks break?** No. `.github/workflows/docs.yml` runs
  on push to `main` and `workflow_dispatch` only — there is no `pull_request`
  trigger, so a fork PR never needs the key. If a PR preview build is added
  later, the committed placeholder keeps it building.
- **Does local development break?** No, that is what the committed `site.ts`
  placeholders are for. `npm run docs:dev` builds them, offline, without a key.
- **Where does the key live?** In 1Password, alongside the SSH keys already
  kept there, and read on a descriptor via `op read` — so it never lands in the
  filesystem for local work. The deploy holds the same key as a GitHub Actions
  secret. Two holders, both able to decrypt.

### Still open

- **Offline backup recipient.** 1Password covers the everyday case, but the
  recipients file should carry a second, offline key as well, so losing the
  account does not take the disclosure with it. Decide during implementation,
  not after — a blob can only be re-encrypted to new recipients while someone
  can still read it.
- **The git history.** Rewrite it, or accept that `3f9308d` keeps the old
  plaintext reachable and treat this as "no new plaintext from here on"?
- **Placeholder wording.** It has to be obviously a placeholder — a disclosure
  that looks filled in but is not is worse than an empty one.
- **Fork instructions.** `CONTRIBUTING.md` and `README.md` need a short section
  saying what to replace and that the encrypted blobs are not theirs to keep.
- **Keeping both sites in step.** `secure-docker-blueprint` plans the same
  mechanism for its own site. Whichever is built first should be the one the
  other copies, down to the file names — two variants of this would be worse
  than one done twice.

### Done when

A decision is written down (here or as an ADR), implemented in the docs build,
and `CONTRIBUTING.md` and `README.md` state plainly what a forker has to
replace before publishing.
