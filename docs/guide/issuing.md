# Issuing & Renewal

## With the wizard (recommended)

The wizard walks you through the three decisions interactively:

```bash
# Fully interactive
./scripts/wizard.sh

# Pre-fill the domain
./scripts/wizard.sh mynas.example.com

# Pre-fill domain and request a wildcard
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

Certificate files appear in `./volumes/output/mynas.example.com/` within about 30 seconds.

## Scripted (for automation)

```bash
# Single domain
docker compose exec \
  -e CERT_DOMAIN=mynas.example.com \
  -e CERT_SAN= \
  acme-certs /scripts/issue.sh

# Domain + wildcard SAN
docker compose exec \
  -e CERT_DOMAIN=example.com \
  -e CERT_SAN='*.example.com' \
  acme-certs /scripts/issue.sh
```

## Output files

All certificates are exported to `./volumes/output/<domain>/`:

```
volumes/output/example.com/
├── cert.pem          # Server certificate only
├── fullchain.pem     # Server cert + intermediate CA  ← use this on most devices
├── privkey.pem       # Private key (chmod 600)
├── ca.pem            # CA certificate
```

**Most devices want `fullchain.pem` + `privkey.pem`.**

## Importing on common devices

| Device | Certificate | Key | Notes |
|--------|-------------|-----|-------|
| **Nginx Proxy Manager** | `fullchain.pem` | `privkey.pem` | Intermediate: `ca.pem` (optional) |
| **Synology DSM** | `cert.pem` | `privkey.pem` | Intermediate: `ca.pem` |
| **OPNsense / pfSense** | `cert.pem` | `privkey.pem` | CA: `ca.pem` |
| **Nginx** | `fullchain.pem` | `privkey.pem` | — |
| **Traefik (file provider)** | `fullchain.pem` | `privkey.pem` | Mount in dynamic config |
| **Windows / IIS** | PFX — see below | — | — |

## PFX conversion (Windows / IIS / some Synology apps)

Some devices cannot import PEM files and require PFX (PKCS#12) format:

```bash
docker compose exec acme-certs \
  /scripts/convert-to-pfx.sh example.com your-chosen-password
```

Creates `./volumes/output/example.com/example.com.pfx`. Use the same password when importing on the target device.

## Renewal

Certificates **renew automatically** via `crond` running inside the container. `acme.sh` checks daily and renews when the certificate is within 30 days of expiry.

Manual renewal (e.g. after a key rotation):

```bash
docker compose exec \
  -e CERT_DOMAIN=example.com \
  acme-certs /scripts/renew.sh
```

To inspect the active crontab inside the container:

```bash
docker compose exec acme-certs crontab -l
```

::: tip ACME account state
Account keys and cert state live in `./volumes/acme/`. This survives container rebuilds — back it up. Losing it means re-registering with the CA.
:::
