---
title: Privacy
description: What this site stores, what it loads, and what the two providers that deliver it record — a short answer, because a static site with no analytics has little to describe.
sidebar: false
aside: false
---

# Privacy

::: warning If you are reading this in a fork
The controller named below is the original author. Replace it with your own
before you publish, or remove the page.
:::

## Short version

This site sets no cookies, runs no analytics script, embeds no third-party
fonts, videos or trackers, and has no forms. There is nothing in the page that
records what you do.

What it cannot avoid is delivery itself: two providers stand between you and
these files, and a request to a server leaves an entry in that server's log.
That is the whole of it, and the sections below say exactly who is involved.

## Who is responsible

Ruben-Paul Nati, Spittelauer Lände 25, 1090 Vienna, Austria. Contact and the
full disclosure are in the [legal notice](/legal).

## What the site itself stores

| | |
|---|---|
| Cookies | none |
| Analytics | none in the page — no script counts you. The request figures the proxy in front produces anyway are described below. |
| Embedded third-party content | none — fonts, scripts and images are served from this domain |
| Forms | none |
| Local storage | one entry, `vitepress-theme-appearance`, written on your first page load with the value `auto` and changed when you use the light/dark switch. It records nothing but that preference, contains no identifier, and leaves your browser at no point. |
| Session storage | none |

The site is static: pages are files, and there is no application behind them
that could keep a record.

## Search

The search box is local. The index is a set of static files served from this
domain and downloaded to your browser, where the search runs. **Your query is
never sent anywhere** — there is no search service, and no request leaves the
page when you type.

## Who delivers this site, and what they see

Serving a page requires a request, and a request has a sender. Two companies sit
in that path, in this order:

**Cloudflare** (Cloudflare, Inc., 101 Townsend Street, San Francisco, CA 94107,
USA) answers for this domain and terminates the TLS connection, so every request
reaches it first. It processes what any proxy processes: IP address, time, the
page requested, the referring page and the browser's user-agent string. It sets
no cookies here. Its responses do ask your browser to report *network errors* —
a failed connection, not a page view — to `a.nel.cloudflare.com`; that is the
one host other than this domain your browser is ever asked to contact.

**GitHub Pages** (GitHub, Inc., 88 Colin P. Kelly Jr. Street, San Francisco, CA
94107, USA) holds the files behind Cloudflare and delivers them over Fastly's
network (Fastly, Inc., USA), which GitHub uses for that purpose. Same request
data, its own logs.

**Purpose and legal basis:** delivering the page you asked for and keeping the
site reachable — Art. 6(1)(f) GDPR. **Retention** is set by those providers
under their own terms, not by us, and neither offers a setting that would switch
the logging off. We receive no raw logs from either. What the domain owner does
see is Cloudflare's dashboard: aggregate figures — how many requests, from which
countries, how much was served from cache. Those are counts, not profiles.

**Transfer to the USA:** both are US companies, so serving a page transfers
request data to a third country. Cloudflare incorporates the EU Standard
Contractual Clauses in its
[data processing addendum](https://www.cloudflare.com/cloudflare-customer-dpa/)
(section 6). GitHub states in its
[privacy statement](https://docs.github.com/site-policy/privacy-policies/github-general-privacy-statement)
that it relies on "the standard contractual clauses published by the European
Commission under Commission Implementing Decision 2021/914".

## If you write to us

The address in the [legal notice](/legal) is an alias: mail sent to it passes
through the alias service SimpleLogin before it reaches the operator's mailbox.
Your address and whatever you write are processed to answer you — Art. 6(1)(f)
GDPR — and kept as long as the correspondence and any follow-up require. There
is no newsletter, and the address is used for nothing else.

## What happens when you follow a link

Links here point at other people's sites — ACME providers, DNS APIs, upstream
projects. Following one is a request to them, and from that moment their privacy
terms apply, not this page's.

**Nothing about you is transmitted to those sites by this one.** No referral
tracking, no identifiers appended to the link.

## The tool itself is not this site

Cert Ops Tool runs on your own machine. What it does with your DNS credentials,
your ACME account and your certificates happens there, between your host and the
providers you configure — this site never sees any of it and has no channel
through which it could.

## Your rights

Where personal data is processed, the GDPR gives you rights of access,
rectification, erasure, restriction, portability and objection, and the right to
complain to a supervisory authority — in Austria the Datenschutzbehörde.

In practice there is very little here to exercise them against: this site holds
no personal data of its own. A request would concern the two providers' server
logs, or an email exchange if you have written to us; the contact address in the
[legal notice](/legal) is the place to start either way.

## Changes

This page describes the site as built. If analytics, a form or an embedded
service is ever added, this page changes in the same commit — otherwise it stops
being true the moment the feature ships.
