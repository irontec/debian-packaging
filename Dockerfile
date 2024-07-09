# Use latest debian by default
ARG distribution=debian
ARG release=bookworm

# Allow configuration of base image
FROM ${distribution}:${release}

MAINTAINER Ivan Alonso <kaian@irontec.com>

# Add support for custom sources in base image
ARG release
COPY *${release}/apt /etc/apt/

# Image environment configuration
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install --no-install-recommends -y git gnupg wget fakeroot dpkg-dev build-essential debconf pbuilder aptitude \
  && apt-get clean

# Add irontec repositories keys
RUN wget http://packages.irontec.com/public.key -q -O /etc/apt/trusted.gpg.d/irontec-debian-repository.asc

# Create building directory
RUN mkdir -p /build/source
RUN chmod 777 -R /build/
ENV HOME=/build/source
WORKDIR /build/source

# Add building directory safe for git
RUN git config --system --add safe.directory /build/source

# Add support for custom sources
ONBUILD ARG release
ONBUILD COPY *sources.list /etc/apt/sources.list.d/
ONBUILD COPY *apt /etc/apt/
ONBUILD COPY *${release}/apt /etc/apt/

# When this image is used on another build:
ONBUILD COPY . debian
ONBUILD RUN apt-get update \
  && /usr/lib/pbuilder/pbuilder-satisfydepends-experimental \
  && apt-get clean

# Default entrypoint
ENTRYPOINT [ "dpkg-buildpackage", "-b" ]
