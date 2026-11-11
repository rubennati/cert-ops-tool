#!/bin/sh
# =========================================================
# Convert PEM certificate to PFX (PKCS#12) format.
# Useful for Windows, Synology, and other devices.
#
# Usage:
#   convert-to-pfx.sh <domain>              # prompts for the password
#   PFX_PASSWORD=... convert-to-pfx.sh <domain>
#   convert-to-pfx.sh <domain> <password>   # deprecated: the password is
#                                           # visible in the process list
#                                           # and in the shell history
# =========================================================
set -eu

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <domain>"
  echo "The password is read from PFX_PASSWORD or asked for interactively."
  exit 1
fi

DOMAIN="$1"

# DOMAIN becomes a directory name under /output — accept host names only
# (a leading "*." for a wildcard-only certificate is allowed).
case "${DOMAIN#\*.}" in
  "" | .* | *..* | *[!A-Za-z0-9.-]*)
    echo "Error: '${DOMAIN}' is not a valid domain name." >&2
    exit 1
    ;;
esac

DIR="/output/${DOMAIN}"

if [ ! -f "${DIR}/privkey.pem" ]; then
  echo "Error: ${DIR}/privkey.pem not found."
  echo "Issue a certificate first with: ./scripts/issue.sh"
  exit 1
fi

if [ "$#" -ge 2 ]; then
  echo "Warning: passing the password as an argument is deprecated." >&2
  echo "         Use PFX_PASSWORD or the interactive prompt instead." >&2
  PFX_PASSWORD="$2"
elif [ -z "${PFX_PASSWORD:-}" ]; then
  if [ ! -t 0 ]; then
    echo "Error: no password. Set PFX_PASSWORD or run with a terminal (docker compose exec without -T)." >&2
    exit 1
  fi
  printf "PFX password: "
  stty -echo
  trap 'stty echo' EXIT INT TERM
  read -r PFX_PASSWORD
  stty echo
  trap - EXIT INT TERM
  echo ""
fi

if [ -z "${PFX_PASSWORD}" ]; then
  echo "Error: the password must not be empty." >&2
  exit 1
fi
export PFX_PASSWORD

# The PFX holds the private key — never group- or world-readable.
umask 077

openssl pkcs12 -export \
  -out "${DIR}/${DOMAIN}.pfx" \
  -inkey "${DIR}/privkey.pem" \
  -in "${DIR}/cert.pem" \
  -certfile "${DIR}/ca.pem" \
  -passout env:PFX_PASSWORD

echo "PFX created: ${DIR}/${DOMAIN}.pfx"
