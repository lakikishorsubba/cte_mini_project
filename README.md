# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
# cte_mini_project



# ----------------------------
# Stage 1: Build
# ----------------------------
FROM ruby:3.4.5 AS builder

WORKDIR /app

# Install build dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    git \
    curl \
    libjemalloc2 \
    libvips42 \
    postgresql-client \
    libpq-dev \
    libyaml-dev \
    pkg-config \
    nodejs \
    yarn \
    && rm -rf /var/lib/apt/lists/*

# Copy Gemfiles and install gems
COPY Gemfile* ./
RUN bundle install --without development test

# Copy the rest of the app
COPY . .

# Precompile Rails assets for production
RUN RAILS_ENV=production bundle exec rails assets:precompile

# ----------------------------
# Stage 2: Production
# ----------------------------
FROM ruby:3.4.5-slim AS production

WORKDIR /app

# Install runtime dependencies only
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    libjemalloc2 \
    libvips42 \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Copy app + gems + precompiled assets from builder
COPY --from=builder /app /app

# Set environment variables
ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true

EXPOSE 3000

# Start Rails server
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
