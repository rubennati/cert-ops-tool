# Security Policy

## Supported versions

This tool is in early-stage development (`0.x`). Only the latest release line receives security fixes.

| Version | Supported |
|---------|-----------|
| 0.1.x   | ✅ |
| < 0.1   | ❌ |

## Reporting a vulnerability

**Please do not open a public GitHub issue for security vulnerabilities.**

Use GitHub's Private Vulnerability Reporting:

1. Go to the [Security tab](https://github.com/rubennati/cert-ops-tool/security) of this repository
2. Click **Report a vulnerability**
3. Fill in the form — title, description, reproduction steps, affected version

What to expect:

- Acknowledgement within **7 days**
- Initial assessment within **14 days**
- Fix timeline depends on severity — critical issues are prioritised

If GitHub Private Vulnerability Reporting is unavailable for any reason, you can contact the maintainer through the email listed on their [GitHub profile](https://github.com/rubennati).

## Scope

In scope:

- The scripts in `scripts/` and `config/`
- The `docker-compose.yml` configuration
- Anything about how the Cloudflare API token is handled
- Filesystem permissions on exported certificate files
- Anything that would allow an attacker to trick the tool into issuing certificates for domains they don't control

Out of scope:

- Vulnerabilities in `acme.sh` itself — report those upstream at https://github.com/acmesh-official/acme.sh/security
- DNS-provider-side issues — report to the DNS provider
- Certificate Authority issues — report to the CA's security contact

## Safe disclosure

We request that researchers:

- Give us a reasonable window to fix before public disclosure (90 days is the default)
- Do not access, modify, or disclose data from third parties
- Do not use the vulnerability to probe other hosts or systems

In return, we commit to:

- Responding quickly
- Keeping you informed of progress
- Acknowledging your contribution in the fix release notes (if you want credit)
