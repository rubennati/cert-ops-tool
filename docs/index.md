---
layout: home

hero:
  text: Create TLS certificates. Upload them where you need them.
  actions:
    - theme: brand
      text: Get Started
      link: /guide/setup
    - theme: alt
      text: GitHub
      link: https://github.com/rubennati/cert-ops-tool

features:
  - icon: 🔒
    title: DNS-01 challenge
    details: No port 80 or 443 needed. Works for internal-only hosts that are never reachable from the internet.
  - icon: 🗝️
    title: Docker Secrets
    details: The Cloudflare API token is stored as a Docker Secret — never in environment variables, never in logs.
  - icon: 🧙
    title: Interactive wizard
    details: Run wizard.sh and answer three questions. Certificate lands in volumes/output/ in under a minute.
  - icon: 🔄
    title: Auto-renewal
    details: crond runs inside the container. acme.sh renews automatically when certs approach expiry.
  - icon: 📄
    title: Standard PEM output
    details: fullchain.pem + privkey.pem + cert.pem + ca.pem — ready for Nginx, Synology DSM, OPNsense, and more.
  - icon: 🪟
    title: PFX export
    details: One command converts to PFX for Windows / IIS / Synology apps that require it.
---
