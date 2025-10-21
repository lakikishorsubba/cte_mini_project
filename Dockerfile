# Use the official Ruby image as a base
FROM ruby:3.4.5-slim
# Set the working directory
WORKDIR /rails
# Install dependencies
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
    && rm -rf /var/lib/apt/lists/*
# Install Node.js and Yarn
COPY Gemfile* ./
# Install bundler
RUN bundle install

COPY . .

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
