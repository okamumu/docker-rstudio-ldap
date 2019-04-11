FROM ubuntu:18.04

ARG RSTUDIO_SERVER_DEB=https://download2.rstudio.org/server/trusty/amd64/rstudio-server-1.2.1335-amd64.deb

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  whois \
  git \
  wget \
  curl \
  ca-certificates \
  gdebi-core \
  locales \
  tzdata &&\
apt-get install -y \
    r-base \
    build-essential \
    gfortran \
    libcurl4-openssl-dev \
    libssl-dev \
    zlib1g-dev \
    libssl1.0.0 \
    libssh2-1-dev \
    libopenblas-base \
    libopenblas-dev

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN wget -O /tmp/rstudio.deb $RSTUDIO_SERVER_DEB &&\
      yes | gdebi /tmp/rstudio.deb &&\
      rm /tmp/rstudio.deb

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libnss-ldap libpam-ldap ldap-auth-client
RUN apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY ldap-auth-config /etc/auth-client-config/profile.d/ldap-auth-config
RUN auth-client-config -a -p lac_ldap

ENV RS_UID        1000
ENV RS_USER       rstudio
ENV RS_HOME       /home/rstudio
ENV RS_PASSWORD   rstudio
ENV RS_GID        1000
ENV RS_GROUP      rstudio
ENV RS_GRANT_SUDO nopass
ENV RS_PORT       8787

ENV LDAP_SERVER        192.168.1.10
ENV LDAP_BASE_DN       dc=example,dc=net

COPY entrypoint.sh /entrypoint.sh

EXPOSE $RS_PORT

CMD ["/entrypoint.sh"]
