# cert-ops-tool — Configuration Reference

Environment variables and runtime options bucketed by effort-vs-value:

- **Mandatory** — every install must set this
- **Nice-to-have** — recommended default unless you have a reason against it
- **Use-case-dependent** — only when a concrete need is named

Items not listed = leave upstream default.

## Structure

| Section | Mandatory | Nice-to-have | Use-case | Don't touch |
|---|---:|---:|---:|---:|
| ACME Identity & Server | 1 | 2 | 1 | — |
| Certificate Defaults | 0 | 2 | 0 | — |
| Container / Runtime | 1 | 2 | 0 | — |
| Secrets | 1 | 0 | 0 | — |
| DNS Provider | 0 | 0 | 1 | — |
| **ENV totals** | **3** | **6** | **2** | **0** |

## 1. ACME Identity & Server

| ENV var | What | Default | Bucket | Rationale / note |
|---|---|---|---|---|
| `ACME_EMAIL` | Email registered with the ACME server. Used for expiry notifications and policy correspondence. | `admin@example.com` placeholder — **must be changed** | **Mandatory** | Real email. CAs may send renewal-failure and revocation notices there. Let's Encrypt sends expiry warnings 20, 10, and 1 day before renewal is needed if renewal failed silently. |
| `ACME_SERVER` | Which ACME CA to use | `letsencrypt` | **Nice-to-have** | Let's Encrypt is the default for good reason (free, reliable, high rate limits for most use-cases). `zerossl` needs separate email registration but has a higher staging-env rate limit. `buypass` is a European alternative. |
| `CERT_KEYLENGTH` | Key type for the certificate | `ec-256` | **Nice-to-have** | ECDSA P-256 is fast, small, broadly supported. Switch to `ec-384` for defense-in-depth, or RSA (`2048`/`3072`/`4096`) only for legacy compatibility with old devices that reject ECDSA. |
| Let's Encrypt staging | Use `letsencrypt_test` instead of `letsencrypt` | — | **Use-case-dependent** | Use-case: debugging rate-limit issues. Staging has much higher limits but issues certs that browsers don't trust. Flip back to `letsencrypt` for production. |

## 2. Certificate Defaults (wizard pre-fills)

These defaults are read by `scripts/wizard.sh` and shown as "press-enter" values. You can override per-invocation.

| ENV var | What | Default | Bucket | Rationale / note |
|---|---|---|---|---|
| `CERT_DOMAIN` | Default domain for the wizard | `example.com` | **Nice-to-have** | Change to your most-used domain so wizard reruns are fast. |
| `CERT_SAN` | Default Subject Alternative Name (wildcard) | `*.example.com` | **Nice-to-have** | Change to your wildcard if applicable. Leave empty for single-domain-only workflows. |

## 3. Container / Runtime

| ENV var | What | Default | Bucket | Rationale / note |
|---|---|---|---|---|
| `APP_TAG` | `neilpang/acme.sh` Docker image tag | `3.1.2` | **Mandatory** | Pin explicitly. Upstream moves fast; implicit `:latest` would break reproducibility. Check compatibility at https://github.com/acmesh-official/acme.sh/releases before bumping. |
| `COMPOSE_PROJECT_NAME` | Compose project prefix for container and volume names | `cert-ops-tool` | **Nice-to-have** | Change only when running multiple instances on the same host (unusual for this tool). |
| `CONTAINER_NAME_APP` | Container name | `${COMPOSE_PROJECT_NAME}` | **Nice-to-have** | Follow the pattern, derived from project name. |
| `TZ` | Timezone inside the container | `UTC` | **Nice-to-have** | Affects log timestamps and `crond` schedule interpretation. Set to your operating timezone for easier log reading. |

## 4. Secrets

| File | What | Bucket | Rationale / note |
|---|---|---|---|
| `.secrets/cf_token.txt` | Cloudflare API token used for DNS-01 challenge | **Mandatory** | Token scope: **Zone > DNS > Edit** on the target zone. **Do not use the Global API Key** — it has full-account access and cannot be scoped. Use the `create-token` path in Cloudflare dashboard → "Edit zone DNS" template → restrict to specific zones. |

## 5. DNS Provider (advanced)

| Topic | Default | Bucket | Rationale / note |
|---|---|---|---|
| Use a DNS provider other than Cloudflare | Cloudflare (`--dns dns_cf` in `issue.sh`) | **Use-case-dependent** | Use-case: your DNS lives at Hetzner, deSEC, DigitalOcean, Route53, etc. `acme.sh` supports 100+ providers. To switch: set provider-specific credentials as env vars (check the [acme.sh DNS API wiki](https://github.com/acmesh-official/acme.sh/wiki/dnsapi)), edit `scripts/issue.sh` (replace `--dns dns_cf` with your provider's flag), and drop the Cloudflare-specific `CF_TOKEN` secret if unused. |

## 6. Non-ENV configuration

### Renewal schedule

`crond` runs inside the container (`command: crond -f` in `docker-compose.yml`). `acme.sh` installs its own crontab entry on first issuance — renewal is triggered daily, with renewal happening when the cert is within 30 days of expiry (configurable via `acme.sh --days N`).

To inspect the current crontab inside the container:

```bash
docker compose exec acme-certs crontab -l
```

### Post-renewal hooks

Not built into this tool. Options:

- Use `acme.sh`'s `--reloadcmd` during issuance (edit `scripts/issue.sh`) — runs after every successful renewal inside the container
- Use a Docker healthcheck / external cron on the host that reads the output dir mtime and triggers SCP / rsync to target devices
- Planned as first-class feature — see Roadmap in README

### ACME account storage

Account keys, certs, and state live in `./volumes/acme/` (mapped to `/acme.sh/` inside the container). This volume survives container rebuilds. **Back it up** — losing it means re-registering with the CA and regenerating account keys.

## Current state vs. defaults

A fresh clone of this repo is **fully default** — you must set at minimum:

1. `ACME_EMAIL` in `.env`
2. `.secrets/cf_token.txt` with a real Cloudflare API token
3. `CERT_DOMAIN` in `.env` (optional if you always pass it to the wizard)

Everything else has sensible defaults.
