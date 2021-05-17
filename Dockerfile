ARG NODE_VERSION=12.22.1

FROM node:${NODE_VERSION} as nodesy
FROM nodesy as builder

WORKDIR /usr/src/app

RUN mkdir /libtmp && \
  apt-get update && \
  apt-get install -y libgl1-mesa-dev libcairo2-dev libjpeg-dev libgif-dev librsvg2-dev libpango1.0-dev dos2unix && \
  find /usr/ -cmin -5 -exec cp --parents \{\} /libtmp 2>>/dev/null \;

RUN cd /var/tmp && \
  apt-get update && \
  apt-get install -y dh-autoreconf libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev && \
  curl -L https://github.com/git/git/archive/refs/tags/v2.31.1.tar.gz --output git.tar.gz && \
  tar -zxf git.tar.gz && \
  cd git-2.31.1 && \
  make configure && \
  ./configure --prefix=/usr && \
  make all && \
  make install

FROM nodesy as app

WORKDIR /usr/src/app

COPY --from=builder /libtmp/usr/ /usr/
COPY --from=builder /usr/libexec/git-core/ /usr/libexec/git-core/