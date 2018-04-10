FROM alpine:3.7

ENV UID 1000
ENV GID 1000
ENV USER htpc
ENV GROUP htpc

ENV OMBI_VERSION 3.0.3164

ENV XDG_CONFIG_HOME /config/

RUN addgroup -S ${GROUP} -g ${GID} && adduser -D -S -u ${UID} ${USER} ${GROUP}  && \
    apk add --no-cache --update curl libcurl tar mono tzdata --update-cache --repository http://alpine.gliderlabs.com/alpine/edge/testing/ --allow-untrusted  && \
    mkdir -p /opt/ombi /config/ombi && curl -sL https://github.com/tidusjar/Ombi/releases/download/v${OMBI_VERSION}/linux.tar.gz  | tar xz /opt/ombi  && \
    chown -R ${USER}:${GROUP} /config/ /opt/ombi/ && \
    rm -rf /tmp/* && \
    apk del curl tar
   
EXPOSE 5000

WORKDIR /opt/ombi/

VOLUME /config/ombi

USER ${USER}

ENTRYPOINT ["mono", "./Ombi.exe"]


