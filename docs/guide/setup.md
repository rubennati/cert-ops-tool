# Setup

## Prerequisites

- **Docker 24.0+** with Compose v2
- A domain managed in **Cloudflare DNS**
- A Cloudflare **API token** with _Zone > DNS > Edit_ permission on the target zone

::: tip Use a scoped API Token — not the Global API Key
In the Cloudflare dashboard: **My Profile → API Tokens → Create Token → "Edit zone DNS" template**.
Restrict it to the specific zone(s) you need certs for. The Global API Key has full-account access and cannot be scoped.
:::

## Install

```bash
git clone https://github.com/rubennati/cert-ops-tool.git
cd cert-ops-tool
```

## 1. Create `.env`

```bash
cp .env.example .env
```

Open `.env` and set at minimum:

| Variable | What to set |
|---|---|
| `ACME_EMAIL` | Your real email address — Let's Encrypt sends renewal-failure warnings here |
| `CERT_DOMAIN` | Your most-used domain (pre-fills the wizard) |
| `APP_TAG` | Leave as-is (`0.2.1`) unless you need a specific version |

## 2. Add the Cloudflare API token

```bash
mkdir -p .secrets
printf '%s' 'your-cloudflare-api-token' > .secrets/cf_token.txt
```

The token is loaded as a Docker Secret at runtime — it never appears in `docker inspect`, logs, or environment dumps.

## 3. Start the container

```bash
docker compose pull
docker compose up -d
```

## 4. Verify

```bash
docker compose logs
```

You should see the startup banner confirming the token and config:

```
================================================
 cert-ops-tool
================================================
 CF_Token      : loaded from Docker Secret
 ACME email    : you@example.com
 ACME server   : letsencrypt
 Key length    : ec-256
 TZ            : UTC
------------------------------------------------
 Ready. Run wizard.sh on the host to issue certs.
 crond starting for automatic renewal...
================================================
```

If `CF_Token : WARNING — secret not found` appears, check that `.secrets/cf_token.txt` exists and is not empty.

## Next step

[Issue your first certificate →](/guide/issuing)
