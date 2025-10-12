# syntax=docker/dockerfile:1
# check=error=true

# ===============================
# Stage 1: Base Image
# ===============================
ARG RUBY_VERSION=3.4.5
FROM ruby:${RUBY_VERSION}-slim AS base

WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential git curl libjemalloc2 libvips postgresql-client libpq-dev libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

# Set environment variables for Rails
ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT="development test"
    

# ===============================
# Stage 2: Build Dependencies
# ===============================
FROM base AS build

# Copy gem files and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache

# Copy application code
COPY . .

# Precompile Bootsnap and assets
RUN bundle exec bootsnap precompile app/ lib/ && \
    ./bin/rails assets:precompile

# ===============================
# Stage 3: Final Runtime Image
# ===============================
FROM base

# Copy built gems and app
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Create and use a non-root user
RUN groupadd --system rails && \
    useradd rails --system --gid rails --create-home && \
    chown -R rails:rails /rails
USER rails

# Expose port 3000
EXPOSE 3000

# Entrypoint for Rails
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start Rails server on 0.0.0.0 so it's accessible from outside
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
