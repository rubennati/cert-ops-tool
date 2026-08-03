---
title: Legal notice
description: Who operates this site, how to reach them, and what licence covers the code as distinct from the documentation.
sidebar: false
aside: false
---

# Legal notice

::: warning If you are reading this in a fork
The details below name the original author. **A disclosure naming someone else
is worse than none at all** — replace them with your own before you publish, or
remove the page. The obligation follows whoever determines the content.
:::

## Who operates this site

| | |
|---|---|
| Operator | Ruben-Paul Nati, MSc |
| Registered as | rnati it solutions e.U. |
| Address | Spittelauer Lände 25, 1090 Wien, Austria |
| Email | <certops@m.rubennati.at> |
| Company register | FN 510221a, Handelsgericht Wien |
| VAT identification number | ATU74404968 |
| Trade authority | Magistrat der Stadt Wien (Gewerbebehörde) |
| Chamber membership | Wirtschaftskammer Wien |
| Trade regulations | [Gewerbeordnung 1994](https://www.ris.bka.gv.at/GeltendeFassung.wxe?Abfrage=Bundesnormen&Gesetzesnummer=10007517) (GewO 1994), in the consolidated version on RIS |

**Purpose of this site, and its editorial focus** (grundlegende Richtung,
§ 25 MedienG): documentation for Cert Ops Tool, a container that issues TLS
certificates with acme.sh over the DNS-01 challenge. It sells nothing, carries
no advertising, and the data that arises anyway is described in
[privacy](/privacy).

## Why hosting does not decide this

A common assumption is that a static site on a hosting platform needs no
disclosure because the platform serves it. That is not the test. **The
obligation follows whoever determines the content**, not whoever operates the
servers — commissioning a technical service provider does not transfer it.

For a site operated commercially or professionally from Austria, the relevant
requirements come from § 5 ECG and §§ 24 and 25 MedienG. What exactly has to
appear depends on the operator's legal form and activity, which is why the
fields above cannot be filled in generically.

**This is not legal advice.** Have the completed version checked against your
actual situation before publishing.

## Code, documentation, and what covers them

Two different bodies of work, and they are not under the same terms:

- **The repository's code** — Dockerfile, Compose files, scripts,
  configuration — is under the
  [PolyForm Noncommercial License 1.0.0](https://github.com/rubennati/cert-ops-tool/blob/main/LICENSE).
  Use it for anything that is not a commercial purpose; commercial use needs a
  separate agreement.
- **This site's text and page structure** are under
  [CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/): use them,
  adapt them, quote them — name the source, link the licence, and keep it out
  of commercial use. That mirrors the line the code licence draws, so the same
  material does not become commercially free by being read on a web page
  instead of in the repository.

The two do not merge where they meet. A command or configuration snippet quoted
on these pages stays under the code licence, whichever page you found it on, so
the same snippet does not carry different terms depending on where it was read.

## Links to other sites

Pages here link to external sources — ACME providers, DNS APIs, upstream
projects. Those sites are not operated by this project, their content is not
ours, and a link is not an endorsement of anything else on the page.

## Reporting a problem

Errors in the documentation: open an issue on the
[repository](https://github.com/rubennati/cert-ops-tool/issues). Security
vulnerabilities: **not** as a public issue — follow the
[security policy](https://github.com/rubennati/cert-ops-tool/blob/main/SECURITY.md).
