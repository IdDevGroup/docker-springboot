MAINTAINER Mark Determan <mdeterman@identifid.com>
FROM anapsix/alpine-java:8_server-jre_unlimited

# Install curl to provide healthcheck
RUN apk add --update curl && \
    rm -rf /var/cache/apk/*

ARG ARTIFACT_NAME
ARG SERVER_PORT=8080
ARG MANAGMENT_PORT=8000

ONBUILD ADD /${ARTIFACT_NAME} /${ARTIFACT_NAME}

# so that it has a file modification time (Docker creates all container files in an "unmodified" state by default)
RUN sh -c 'touch /${ARTIFACT_NAME}'

EXPOSE ${SERVER_PORT}
EXPOSE ${MANAGMENT_PORT}

HEALTHCHECK --timeout=10s CMD curl --fail http://localhost:${MANAGMENT_PORT}/health || exit 1

ENTRYPOINT ["java"]
CMD ["-Djava.security.egd=file:/dev/./urandom", "-jar", "/${ARTIFACT_NAME}"]