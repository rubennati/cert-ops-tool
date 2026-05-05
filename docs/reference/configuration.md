# Configuration Reference

All settings are in `.env`. Buckets:

- **Mandatory** — must be set on every install
- **Nice-to-have** — recommended to review; sensible defaults exist
- **Use-case-dependent** — only relevant for specific scenarios

## ACME Identity & Server

| Variable | Default | Bucket | Notes |
|---|---|---|---|
| `ACME_EMAIL` | `admin@example.com` | **Mandatory** | Real email. Let's Encrypt sends expiry warnings 20, 10, and 1 day before a missed renewal. |
| `ACME_SERVER` | `letsencrypt` | Nice-to-have | `letsencrypt` (default), `zerossl`, `buypass`. ZeroSSL needs separate email registration; Buypass is a European alternative. |
| `CERT_KEYLENGTH` | `ec-256` | Nice-to-have | ECDSA P-256 is fast and broadly supported. Use `ec-384` for defense-in-depth, or `2048`/`3072`/`4096` (RSA) for legacy devices that reject ECDSA. |
| `letsencrypt_test` | — | Use-case | Use `ACME_SERVER=letsencrypt_test` when debugging rate-limit issues — much higher limits but issues certs browsers don't trust. Switch back to `letsencrypt` for production. |

## Certificate Defaults

Pre-fill values for the wizard. You can override these per invocation.

| Variable | Default | Bucket | Notes |
|---|---|---|---|
| `CERT_DOMAIN` | `example.com` | Nice-to-have | Set to your most-used domain so wizard reruns are one Enter press. |
| `CERT_SAN` | `*.example.com` | Nice-to-have | Default wildcard SAN. Leave empty for single-domain-only workflows. |

## Container / Runtime

| Variable | Default | Bucket | Notes |
|---|---|---|---|
| `APP_TAG` | `0.2.1` | **Mandatory** | Pin explicitly. Check [releases](https://github.com/rubennati/cert-ops-tool/releases) before bumping. |
| `COMPOSE_PROJECT_NAME` | `cert-ops-tool` | Nice-to-have | Change only when running multiple instances on the same host. |
| `CONTAINER_NAME_APP` | `${COMPOSE_PROJECT_NAME}` | Nice-to-have | Derived from project name — rarely needs changing. |
| `TZ` | `UTC` | Nice-to-have | Affects log timestamps and crond schedule interpretation. Set to your local timezone for easier log reading. |

## Secrets

| File | Bucket | Notes |
|---|---|---|
| `.secrets/cf_token.txt` | **Mandatory** | Cloudflare API token. Scope: **Zone > DNS > Edit** on the target zone only. Do not use the Global API Key. |

## DNS Provider

By default cert-ops-tool uses Cloudflare (`--dns dns_cf`). To switch to another provider:

1. Look up your provider's credentials in the [acme.sh DNS API wiki](https://github.com/acmesh-official/acme.sh/wiki/dnsapi)
2. Add the required env vars to `.env`
3. Edit `scripts/issue.sh` — replace `--dns dns_cf` with your provider's flag

`acme.sh` supports 100+ DNS providers. The Cloudflare-specific `CF_TOKEN` secret can be removed if unused.

## Minimum required changes

A fresh clone needs exactly three things before it works:

1. `ACME_EMAIL` in `.env` — set to your real email
2. `.secrets/cf_token.txt` — your Cloudflare API token
3. _(optional)_ `CERT_DOMAIN` — pre-fill for the wizard

Everything else has sensible defaults.
