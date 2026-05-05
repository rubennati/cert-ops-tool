<div align="center">

# cert-ops-tool

**TLS certificates for devices that don't sit behind a reverse proxy.**

NAS · routers · firewalls · Proxmox · mail servers — DNS-01 challenge, Docker Secrets, zero open ports required.

[![License](https://img.shields.io/badge/License-PolyForm_NC_1.0-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-0.2.1-blue)](CHANGELOG.md)
[![Docker](https://img.shields.io/badge/GHCR-cert--ops--tool-2496ED?logo=docker&logoColor=white)](https://github.com/rubennati/cert-ops-tool/pkgs/container/cert-ops-tool)
[![Docs](https://img.shields.io/badge/docs-rubennati.github.io-green)](https://rubennati.github.io/cert-ops-tool/)

</div>

---

Built on [`acme.sh`](https://github.com/acmesh-official/acme.sh) with DNS-01 challenge (no port-80 open, works for internal-only hosts). Ships as a single Docker Compose service with scripted workflows for issuing, renewing, and exporting certificates.

> **License**: [PolyForm Noncommercial 1.0.0](LICENSE) — free for personal, educational, research, and other noncommercial use. Commercial use requires a separate arrangement.

## Why this exists

`acme.sh` is powerful but raw — exposing it as a day-to-day tool means wrapping it with sensible defaults, Docker Secrets for API tokens, ready-to-consume output files, and a wizard for the common path. This repo packages that wrapping:

- Cloudflare DNS-01 out of the box (other providers documented, easy to adapt)
- Cloudflare API token as Docker Secret, never in environment
- Output in standard locations (`fullchain.pem` + `privkey.pem` + `cert.pem` + `ca.pem`) per domain
- Interactive wizard for issuing + scripted commands for automation
- PFX conversion for Windows / IIS / Synology DSM
- Automatic renewal via in-container `crond`

## How it works

1. A lightweight container runs `crond` in the background for automatic renewal
2. You issue certificates via the **wizard** or direct commands
3. Certificates are exported to `./volumes/output/<domain>/` as standard PEM files
4. The Cloudflare API token is stored as a Docker Secret in `.secrets/`, never in environment variables

## Setup

```bash
git clone https://github.com/rubennati/cert-ops-tool.git
cd cert-ops-tool

# 1. Create .env
cp .env.example .env
# Edit: ACME_EMAIL, CERT_DOMAIN (optional: ACME_SERVER, CERT_KEYLENGTH)

# 2. Cloudflare API token as Docker Secret
#    Token needs: Zone > DNS > Edit on the target zone.
#    Use a scoped API Token, NOT the Global API Key.
mkdir -p .secrets
printf '%s' 'your-cloudflare-api-token' > .secrets/cf_token.txt

# 3. Start the container
docker compose pull
docker compose up -d
```

## Issuing a certificate

### With the wizard (recommended)

```bash
# Fully interactive
./scripts/wizard.sh

# With domain argument (single domain)
./scripts/wizard.sh mynas.example.com

# With domain + wildcard shortcut
./scripts/wizard.sh example.com -w
```

Example session:

```
Certificate Wizard
==================

Domain: mynas.example.com
Type: [1] Single domain  [2] Wildcard (*.mynas.example.com)  [1]: 1
Key type [ec-256|ec-384|2048|3072|4096] [ec-256]:
ACME server [letsencrypt|zerossl|buypass] [letsencrypt]:

Configuration:
  Domain:     mynas.example.com
  Type:       single domain (no wildcard)
  Key type:   ec-256
  ACME:       letsencrypt

Issue certificate now? [y/N]: y
```

Certificate files appear in `./volumes/output/mynas.example.com/`.

### Scripted (for automation)

```bash
# Single domain
docker compose exec \
  -e CERT_DOMAIN=mynas.example.com \
  -e CERT_SAN= \
  acme-certs /scripts/issue.sh

# Domain + wildcard
docker compose exec \
  -e CERT_DOMAIN=example.com \
  -e CERT_SAN='*.example.com' \
  acme-certs /scripts/issue.sh
```

## Renewal

Certificates **renew automatically** via `crond` inside the container (default schedule handled by `acme.sh` itself — typically every 60 days).

Manual renewal:

```bash
docker compose exec \
  -e CERT_DOMAIN=example.com \
  acme-certs /scripts/renew.sh
```

## Output

```
volumes/output/example.com/
├── cert.pem          # Server certificate
├── fullchain.pem     # Server cert + intermediate CA
├── privkey.pem       # Private key (chmod 600)
└── ca.pem            # CA certificate
```

**Most devices need** `fullchain.pem` + `privkey.pem`.

## Importing on common devices

| Device | What to upload |
|--------|---------------|
| **Nginx Proxy Manager** | Cert: `fullchain.pem`, Key: `privkey.pem`, Intermediate: `ca.pem` (optional) |
| **Synology DSM** | Cert: `cert.pem`, Key: `privkey.pem`, Intermediate: `ca.pem` |
| **OPNsense / pfSense** | Cert: `cert.pem`, CA: `ca.pem`, Key: `privkey.pem` |
| **Generic / Nginx** | `fullchain.pem` + `privkey.pem` |
| **Traefik (file provider)** | Mount `fullchain.pem` + `privkey.pem` in dynamic config |
| **Windows / IIS** | Needs PFX — see below |

### PFX conversion (Windows / IIS / some Synology apps)

```bash
docker compose exec acme-certs \
  /scripts/convert-to-pfx.sh example.com your-chosen-password
```

Creates `./volumes/output/example.com/example.com.pfx`. Enter the same password on the target device during import.

## Security model

- **Cloudflare API token** is a Docker Secret (`.secrets/cf_token.txt`), never an environment variable
- **Private keys** are created with `chmod 600` inside the container
- **`security_opt: no-new-privileges:true`** on the container
- **Output volume** is bind-mounted; distribution to target devices is your responsibility (SCP, rsync, restic, etc.) — this tool does not transmit keys anywhere itself

## Built on

- [`acme.sh`](https://github.com/acmesh-official/acme.sh) (GPL-3.0) — the ACME client that does the actual work. We use the official `neilpang/acme.sh` Docker image as the base runtime.
- [Cloudflare DNS API](https://developers.cloudflare.com/api/) — for the DNS-01 challenge

This repo's own code (scripts, compose, entrypoint wrapper, docs) is under [PolyForm Noncommercial 1.0.0](LICENSE). Dependencies keep their own licenses.

## Roadmap

- Additional DNS providers beyond Cloudflare (Hetzner, DigitalOcean, deSEC, etc.)
- Automatic distribution via API to target devices (Proxmox VE, Synology DSM, OPNsense, Nginx Proxy Manager)
- Optional web UI for issuing + monitoring expiry
- Scheduled expiry alerts (ntfy / Gotify / email / webhook)

See [CHANGELOG.md](CHANGELOG.md) for released versions.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Code of conduct: [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

## Details

- [CONFIG.md](CONFIG.md) — configuration reference (mandatory / nice-to-have / use-case-dependent)
- [SECURITY.md](SECURITY.md) — vulnerability reporting
- [CHANGELOG.md](CHANGELOG.md) — versioned change log
