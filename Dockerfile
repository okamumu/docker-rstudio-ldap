FROM ubuntu:18.04

RUN apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    sudo \
    whois \
    git \
    wget \
    curl \
    ca-certificates \
    gdebi-core \
    locales \
    r-base \
    tzdata \
    build-essential \
    gfortran \
    libcurl4-openssl-dev \
    libssl-dev \
    zlib1g-dev \
    libssl1.0.0 \
    libssh2-1-dev \
    libopenblas-base \
    libopenblas-dev \
    psmisc \
    libapparmor1 \
    libxml2-dev \
    libgmp3-dev \
    libmpfr-dev \
    libclang-dev &&\
  locale-gen en_US.UTF-8 &&\
  apt-get clean &&\
  rm -rf /var/lib/apt/lists/*

ENV TZ=Asia/Tokyo 
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ARG RSTUDIO_SERVER_DEB=https://download2.rstudio.org/server/trusty/amd64/rstudio-server-1.2.5033-amd64.deb

RUN wget -O /tmp/rstudio.deb $RSTUDIO_SERVER_DEB &&\
      yes | gdebi /tmp/rstudio.deb &&\
      rm /tmp/rstudio.deb

ENV RS_UID        1000
ENV RS_USER       rstudio
ENV RS_HOME       /home/rstudio
ENV RS_PASSWORD   rstudio
ENV RS_GID        1000
ENV RS_GROUP      rstudio
ENV RS_GRANT_SUDO nopass
ENV RS_PORT       8787

COPY entrypoint.sh /entrypoint.sh

EXPOSE $RS_PORT

CMD ["/entrypoint.sh"]
