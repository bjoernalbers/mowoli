FROM ruby:2.0
RUN apt-get update \
  && apt-get -y install nodejs \
  && rm -rf /var/lib/apt/lists/*
WORKDIR /opt/mowoli
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .
RUN mkdir -p var/sqlite3
VOLUME /opt/mowoli/var/sqlite3
