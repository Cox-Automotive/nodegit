ARG NODE_VERSION=12.22.1

FROM node:${NODE_VERSION}-buster as node
FROM node as builder

WORKDIR /usr/src/app

RUN wget 'http://http.us.debian.org/debian/pool/main/g/git/git-man_2.31.1-1_all.deb' && \
  dpkg -i git-man_2.31.1-1_all.deb && \
  wget 'http://http.us.debian.org/debian/pool/main/g/git/git_2.31.1-1_amd64.deb' && \
  dpkg -i git_2.31.1-1_amd64.deb

RUN mkdir /libtmp && \
  apt-get update && \
  apt-get install -y libgl1-mesa-dev libcairo2-dev libjpeg-dev libgif-dev libpango1.0-dev && \
  find /usr/lib/x86_64-linux-gnu/ -cmin -5 -exec cp "{}" /libtmp 2>>/dev/null \;