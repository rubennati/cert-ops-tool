#!/bin/sh
# =========================================================
# Renew an existing certificate and re-export.
# =========================================================
set -eu

: "${CERT_DOMAIN:?CERT_DOMAIN missing}"

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

acme.sh --home "${ACME_HOME}" --renew -d "${CERT_DOMAIN}"

acme.sh --home "${ACME_HOME}" --install-cert -d "${CERT_DOMAIN}" \
  --key-file       "${OUT_DIR}/privkey.pem" \
  --cert-file      "${OUT_DIR}/cert.pem" \
  --fullchain-file "${OUT_DIR}/fullchain.pem" \
  --ca-file        "${OUT_DIR}/ca.pem"

chmod 600 "${OUT_DIR}/privkey.pem" || true

echo "Renewal complete: ${OUT_DIR}"
