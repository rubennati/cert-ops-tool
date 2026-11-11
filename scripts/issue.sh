#!/bin/sh
# =========================================================
# Issue a new certificate via DNS-01 (Cloudflare).
# Reads CF_Token from Docker Secret if available.
# =========================================================
set -eu

: "${ACME_EMAIL:?ACME_EMAIL missing}"
: "${CERT_DOMAIN:?CERT_DOMAIN missing}"
: "${CERT_KEYLENGTH:=ec-256}"
: "${ACME_SERVER:=letsencrypt}"

# Load CF_Token from Docker Secret if not already set
if [ -z "${CF_Token:-}" ] && [ -f /run/secrets/CF_TOKEN ]; then
  CF_Token="$(cat /run/secrets/CF_TOKEN)"
  export CF_Token
fi
: "${CF_Token:?CF_Token missing – check .secrets/cf_token.txt}"

# CERT_DOMAIN becomes a directory name under /output — accept host names
# only (a leading "*." for a wildcard-only certificate is allowed).
case "${CERT_DOMAIN#\*.}" in
  "" | .* | *..* | *[!A-Za-z0-9.-]*)
    echo "Error: CERT_DOMAIN '${CERT_DOMAIN}' is not a valid domain name." >&2
    exit 1
    ;;
esac

# Key material must never be created group- or world-readable.
umask 077

ACME_HOME="/acme.sh"
OUT_DIR="/output/${CERT_DOMAIN}"

mkdir -p "${OUT_DIR}"

# Register ACME account (idempotent)
acme.sh --home "${ACME_HOME}" \
  --register-account -m "${ACME_EMAIL}" \
  --server "${ACME_SERVER}" || true

# Issue certificate
if [ -n "${CERT_SAN:-}" ]; then
  acme.sh --home "${ACME_HOME}" --issue \
    --dns dns_cf \
    -d "${CERT_DOMAIN}" \
    -d "${CERT_SAN}" \
    --keylength "${CERT_KEYLENGTH}" \
    --server "${ACME_SERVER}"
else
  acme.sh --home "${ACME_HOME}" --issue \
    --dns dns_cf \
    -d "${CERT_DOMAIN}" \
    --keylength "${CERT_KEYLENGTH}" \
    --server "${ACME_SERVER}"
fi

# Export certificate files
acme.sh --home "${ACME_HOME}" --install-cert -d "${CERT_DOMAIN}" \
  --key-file       "${OUT_DIR}/privkey.pem" \
  --cert-file      "${OUT_DIR}/cert.pem" \
  --fullchain-file "${OUT_DIR}/fullchain.pem" \
  --ca-file        "${OUT_DIR}/ca.pem"

chmod 600 "${OUT_DIR}/privkey.pem" || true

echo "Certificate exported to ${OUT_DIR}"
