# ---------- Stage 1: Builder ----------
FROM ruby:3.2-slim AS builder

WORKDIR /app
ENV RAILS_ENV=production

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential git curl libvips42 libpq-dev libyaml-dev pkg-config postgresql-client && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists/*

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

# Copy app source
COPY . .

# Precompile assets
RUN RAILS_ENV=production SECRET_KEY_BASE=dummy rails assets:precompile


# ---------- Stage 2: Runtime ----------
FROM ruby:3.2-slim AS runtime

WORKDIR /app
ENV RAILS_ENV=production

# Install minimal runtime deps
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends libvips42 postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Copy compiled app from builder
COPY --from=builder /app /app

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
