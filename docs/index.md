---
layout: home

hero:
  text: Create TLS certificates. Upload them where you need them.
  tagline: rubennati / cert-ops-tool
  actions:
    - theme: brand
      text: Get Started
      link: /guide/setup
    - theme: alt
      text: GitHub
      link: https://github.com/rubennati/cert-ops-tool

features:
  - icon: 🧙
    title: Interactive wizard
    details: Run wizard.sh and answer three questions. Certificate lands in volumes/output/.
  - icon: 📄
    title: Standard PEM output
    details: fullchain.pem + privkey.pem + cert.pem + ca.pem — ready for Nginx, Synology DSM, OPNsense, and more.
  - icon: 🪟
    title: PFX export
    details: One command converts to PFX for Windows / IIS / Synology apps that require it.
  - icon: 🔄
    title: Auto-renewal
    details: crond runs inside the container. acme.sh renews automatically when certs approach expiry.
  - icon: ✳️
    title: Wildcards and SANs
    details: Single domain, *.example.com wildcard, or multi-domain SAN — same wizard.
  - icon: 🔒
    title: DNS-01 challenge
    details: No port 80 or 443 needed. No inbound connection to the device.
  - icon: 🔀
    title: Multiple ACME servers
    details: Let's Encrypt by default. ZeroSSL and BuyPass selectable without code changes.
  - icon: 📦
    title: Multi-arch image
    details: amd64 and arm64 on GHCR. Runs on Raspberry Pi as well as x86 hosts.
  - icon: ⚙️
    title: Built on acme.sh
    details: Uses the official neilpang/acme.sh image as base. No fork, no rewrite.
---
