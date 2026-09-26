FROM ruby:3.4-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    inotify-tools \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN git config --global --add safe.directory /site

WORKDIR /site

COPY Gemfile Gemfile.lock* ./
RUN bundle install

EXPOSE 4000
