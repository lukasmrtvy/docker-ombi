FROM ubuntu:17.10

ENV UID 1000
ENV GID 1000
ENV USER htpc
ENV GROUP htpc

ENV OMBI_VERSION 3.0.3164

ENV XDG_CONFIG_HOME /config/

RUN groupadd -r -g ${GID} ${GROUP} && adduser --disabled-password --uid ${UID} --ingroup ${GROUP} --gecos '' ${USER} && \
    apt update && apt install -y curl tar ca-certificates tzdata  --no-install-recommends
    
RUN apt install -y libicu-dev libunwind8 libcurl4-openssl-dev  --no-install-recommends
    
RUN mkdir -p /opt/ombi /config/ombi && curl -sSL https://github.com/tidusjar/Ombi/releases/download/v${OMBI_VERSION}/linux.tar.gz  | tar xz -C /opt/ombi  && \
    chown -R ${USER}:${GROUP} /config/ /opt/ombi/ && \
    rm -rf /tmp/*  
   
EXPOSE 5000

WORKDIR /opt/ombi/

VOLUME /config/ombi

USER ${USER}

ENTRYPOINT ["./Ombi"]
