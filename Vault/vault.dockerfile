FROM alpine:latest AS builder
ARG VAULT_VERSION=1.3.0
ENV VAULT_VERSION ${VAULT_VERSION}
RUN mkdir /vault 
RUN apk --no-cache add bash ca-certificates wget

FROM builder AS preVault
RUN wget --quiet --output-document=/tmp/vault.zip \
    https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && \
    unzip /tmp/vault.zip -d /vault && \
    rm -f /tmp/vault.zip && \
    chmod +x /vault
RUN addgroup vault && \
    adduser -S -G vault vault && \
    chown -R vault:vault /vault
ENV PATH="PATH=$PATH:$PWD/vault"

FROM preVault AS VAULT
COPY ./config/vault-conf.json /vault/config/vault-conf.json
#VOLUME /vault/logs
#VOLUME /vault/config
#VOLUME /vault/file
EXPOSE 8200
ENTRYPOINT [ "vault" ]
