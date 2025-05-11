FROM ruby:3.2-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential git curl nodejs libxml2-dev libxslt1-dev libssl-dev zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /srv/jekyll

COPY Gemfile ./

RUN bundle install

COPY . .

EXPOSE 4000
