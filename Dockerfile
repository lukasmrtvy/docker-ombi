FROM alpine:3.7

ENV UID 1000
ENV GID 1000
ENV USER htpc
ENV GROUP htpc

ENV OMBI_VERSION 2.2.1

ENV XDG_CONFIG_HOME /config/

RUN addgroup -S ${GROUP} -g ${GID} && adduser -D -S -u ${UID} ${USER} ${GROUP}  && \
    apk add --no-cache --update curl libcurl tar mono tzdata --update-cache --repository http://alpine.gliderlabs.com/alpine/edge/testing/ --allow-untrusted  && \
    mkdir -p /opt/ombi /config/ombi && curl -sL https://github.com/tidusjar/Ombi/releases/download/v${OMBI_VERSION}/Ombi.zip -O /tmp/Ombi.zip ; unzip /tmp/Ombi.zip -d /opt/ombi && \
    chown -R ${USER}:${GROUP} /config/ /opt/ombi/ && \
    rm -rf /tmp/* && \
    apk del curl tar
   
EXPOSE 9117 

WORKDIR /opt/

VOLUME /config/ombi

USER ${USER}

RUN ls -lha /opt/ombi 

ENTRYPOINT ["mono", "ombi/Ombi.exe"]
