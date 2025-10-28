# Builder Stage — Install deps and precompile

FROM ruby:3.4.5-slim AS builder

WORKDIR /rails

ENV RAILS_ENV=production \
    BUNDLE_WITHOUT="development test" \
    DEBIAN_FRONTEND=noninteractive

# Install required OS packages
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    git \
    curl \
    libjemalloc2 \
    libvips42 \
    libpq-dev \
    libyaml-dev \
    pkg-config \
    nodejs \
    yarn \
    postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Copy gem definitions and install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4

# Copy full app and precompile assets
COPY . .
RUN bundle exec rails assets:precompile

# 2️⃣ Final Runtime Stage — Lightweight image
FROM ruby:3.4.5-slim

WORKDIR /rails

ENV RAILS_ENV=production \
    BUNDLE_WITHOUT="development test" \
    DEBIAN_FRONTEND=noninteractive

# Install only runtime dependencies
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    libjemalloc2 \
    libvips42 \
    postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Copy built gems & app from builder stage
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /rails /rails

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
