# Base image pinned by tag and digest. Dependabot proposes updates to both.
FROM neilpang/acme.sh:3.1.7@sha256:786b2ce1f0d6142b8bf3b8ac92b583070300fbb3147d5758fa5ca3fdf90a42f4

# Pull in Alpine security fixes published after the base image was built.
RUN apk upgrade --no-cache

# Bake in operational scripts and entrypoint.
# wizard.sh is a host-side script and is NOT included here —
# it calls `docker compose exec` and must run on the host.
COPY scripts/issue.sh           /scripts/issue.sh
COPY scripts/renew.sh           /scripts/renew.sh
COPY scripts/convert-to-pfx.sh  /scripts/convert-to-pfx.sh
COPY config/entrypoint.sh       /config/entrypoint.sh

RUN chmod +x \
    /scripts/issue.sh \
    /scripts/renew.sh \
    /scripts/convert-to-pfx.sh \
    /config/entrypoint.sh

ENTRYPOINT ["/bin/sh", "/config/entrypoint.sh"]
CMD ["/bin/sh", "-c", "crond -f"]
