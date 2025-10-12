FROM ruby:3.4.5-slim

# Set working directory
WORKDIR /rails

# Set noninteractive to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
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
    && rm -rf /var/lib/apt/lists/*

# Copy Gemfile and install gems
COPY Gemfile* ./
RUN bundle install

# Copy the rest of the app
COPY . .

# Precompile assets (if Rails API with frontend, optional)
# RUN bundle exec rails assets:precompile

# Expose default port
EXPOSE 3000

# Start Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
