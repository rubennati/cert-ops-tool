FROM neilpang/acme.sh:3.1.2

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
