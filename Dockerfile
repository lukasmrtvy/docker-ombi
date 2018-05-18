FROM ubuntu:18.04

ENV UID 1000
ENV GID 1000
ENV USER htpc
ENV GROUP htpc

ENV OMBI_VERSION 3.0.3330

LABEL VERSION=${OMBI_VERSION}
LABEL BUILD_DATE="$(date --iso-8601=seconds)"

ENV XDG_CONFIG_HOME /config/

RUN groupadd -r -g ${GID} ${GROUP} && adduser --disabled-password --uid ${UID} --ingroup ${GROUP} --gecos '' ${USER} && \
    apt update && apt install -y curl tar ca-certificates tzdata  --no-install-recommends
    
RUN apt install -y libicu-dev libunwind8 libcurl4-openssl-dev --no-install-recommends

# workaround
RUN  apt-get download libssl1.0-dev && dpkg-deb -X libssl1.0-dev_1.0.2n-1ubuntu5_amd64.deb && rm -rf libssl1.0-dev_1.0.2n-1ubuntu5_amd64.deb

    
RUN mkdir -p /opt/ombi /config/ombi && curl -sSL https://github.com/tidusjar/Ombi/releases/download/v${OMBI_VERSION}/linux.tar.gz  | tar xz -C /opt/ombi  && \
    chown -R ${USER}:${GROUP} /config/ /opt/ombi/ && \
    rm -rf /tmp/*  
   
EXPOSE 5000

WORKDIR /opt/ombi/

VOLUME /config/ombi

USER ${USER}

ENTRYPOINT ["./Ombi"]
