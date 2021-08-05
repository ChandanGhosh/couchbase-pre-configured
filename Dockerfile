FROM couchbase:latest
ENV USERNAME=Administrator
ENV PASSWORD=password
ENV BUCKET=todo
COPY entrypoint.sh /setup-script.sh
HEALTHCHECK --interval=5s --timeout=3s CMD curl -u ${USERNAME}:${PASSWORD} --fail http://localhost:8091/pools || exit 1
ENTRYPOINT ["/setup-script.sh"]