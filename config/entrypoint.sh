#!/bin/sh
# =========================================================
# Load CF_Token from Docker Secret at runtime.
# acme.sh does not support _FILE env vars natively.
# =========================================================
set -e

echo "================================================"
echo " cert-ops-tool"
echo "================================================"

if [ -f /run/secrets/CF_TOKEN ]; then
  export CF_Token="$(cat /run/secrets/CF_TOKEN)"
  echo " CF_Token      : loaded from Docker Secret"
else
  echo " CF_Token      : WARNING — secret not found"
fi

echo " ACME email    : ${ACME_EMAIL:-<not set>}"
echo " ACME server   : ${ACME_SERVER:-letsencrypt}"
echo " Key length    : ${CERT_KEYLENGTH:-ec-256}"
echo " TZ            : ${TZ:-UTC}"
echo "------------------------------------------------"
echo " Ready. Run wizard.sh on the host to issue certs."
echo " crond starting for automatic renewal..."
echo "================================================"

exec "$@"
