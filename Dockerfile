ARG release
FROM debian:${release}

MAINTAINER Ivan Alonso <kaian@irontec.com>

# Image environment configuration
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install --no-install-recommends -y gnupg wget fakeroot dpkg-dev build-essential debconf pbuilder aptitude \
  && apt-get clean

# Add irontec repositories keys
RUN wget http://packages.irontec.com/public.key -q -O /etc/apt/trusted.gpg.d/irontec-debian-repository.asc

# Add support for custom sources
ONBUILD COPY sources.lis[t] /etc/apt/sources.list.d/

# When this image is used on another build:
ONBUILD COPY . debian
ONBUILD RUN apt-get update \
  && /usr/lib/pbuilder/pbuilder-satisfydepends-experimental \
  && apt-get clean

# Create building workdir
RUN mkdir -p /build/source
WORKDIR /build/source

# Default entrypoint
ENTRYPOINT [ "dpkg-buildpackage", "-b" ]
