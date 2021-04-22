ARG NODE_VERSION=12.22.1

FROM node:${NODE_VERSION} as node
FROM node as builder

WORKDIR /usr/src/app

RUN apt-get update && \
  apt-get install dh-autoreconf libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev -y && \
  cd /var/tmp && \
  curl -L https://github.com/git/git/archive/refs/tags/v2.31.1.tar.gz --output git.tar.gz && \
  tar -zxf git.tar.gz && \
  cd git-2.31.1 && \
  make configure && \
  ./configure --prefix=/usr && \
  make all && \
  make install

RUN mkdir /libtmp && \
  apt-get install -y libgl1-mesa-dev libcairo2-dev libjpeg-dev libgif-dev libpango1.0-dev && \
  find /usr/lib/x86_64-linux-gnu/ -cmin -5 -exec cp "{}" /libtmp 2>>/dev/null \;

FROM node as app

WORKDIR /usr/src/app

COPY --from=builder /libtmp/ /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/bin/git* /usr/bin/
COPY --from=builder /usr/libexec/git-core/ /usr/libexec/git-core/