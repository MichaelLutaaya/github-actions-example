################################################################################
## Base Image
################################################################################

ARG RUBY_VERSION=3.0.1
ARG DEBIAN_RELEASE=buster
FROM ruby:$RUBY_VERSION-slim-$DEBIAN_RELEASE AS base

ARG BUNDLER_VERSION=2.2.21
ARG PG_MAJOR=13

# According to the Docker docs, arguments declared before `FROM` are outside of the build stage and can’t be used in
# instructions after the `FROM`. A workaround is to re-declare the argument.
# https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG DEBIAN_RELEASE=buster

RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
  build-essential \
  curl \ 
  gnupg2 \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && echo "deb http://apt.postgresql.org/pub/repos/apt $DEBIAN_RELEASE-pgdg main $PG_MAJOR" > /etc/apt/sources.list.d/pgdg.list

COPY .dockerdev/Aptfile /tmp/Aptfile
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -yq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
  libpq-dev \
  postgresql-client-$PG_MAJOR \
  $(grep -v '^\s*#' /tmp/Aptfile | xargs) \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3

RUN gem update --system \
  && gem install bundler:$BUNDLER_VERSION

RUN mkdir -p /app
WORKDIR /app

################################################################################
## Production Image
################################################################################

FROM base AS production

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

ENV RAILS_ENV=production
RUN ./bin/bundle config --local deployment true && ./bin/bundle install

COPY . /app
