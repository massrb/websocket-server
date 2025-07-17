# ===========================
# Build stage
# ===========================
FROM ruby:3.3 AS build

# Install system dependencies needed for gems to compile
RUN apt-get update -qq && \
    apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    curl \
    git

# Set working directory
WORKDIR /rails

# Install bundler and app dependencies
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install

# Copy the full Rails app
COPY . .

# Precompile assets (optional, if you use sprockets or webpacker)
# RUN bundle exec rake assets:precompile

# ===========================
# Runtime stage
# ===========================
FROM ruby:3.3 AS final

# Install runtime dependencies (libpq runtime)
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /rails

# Copy over gems and app from build stage
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Create a non-root user to run the app
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

USER rails

# Default command
CMD ["bin/rails", "server"]
