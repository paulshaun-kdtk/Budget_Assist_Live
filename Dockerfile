# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.2.2
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"


# Throw-away build stage to reduce size of final image
FROM base as build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libvips pkg-config libpq-dev  # Add this line

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# ...
RUN gem install bootstrap-sass -v 3.4.1

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Adjust binfiles to be executable on Linux
RUN chmod +x bin/* && \
    sed -i "s/\r$//g" bin/* && \
    sed -i 's/ruby\.exe$/ruby/' bin/*


# Precompile assets for production using RAILS_MASTER_KEY environment variable

ARG RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY=$RAILS_MASTER_KEY
RUN RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 RAILS_MASTER_KEY=28NmdTr6M1eFHbd9nqaLR/pm7LwtQuF0qTBatGovoDsYcDdxiclQkZ3Iit4g+DQgznLwwEAaQX/c+N4+C9s6aipAif+dIxAQ4PQj2HNr8ntkLM/smINfmALYEj5H9iNAzg2gajReaBstU68wffo+PdPS2nvsnDy25EJzPbWprdqB9TMG3C2F17LVlbJBca8FAoQtzTRzUnRXMk0zrEPpXjSpeqrJb8aXTCVNo3euc3WoslPMem5i7fagLWHSa5KwsWtBvaEXafFaPbFQQI5wnR4GBpKzPHN1g99KOINduKRHMN0eSSt5pgnUv6hZKZc+o4+geBJaUJLYFtNi+Up34xRtstuC4P8Uz8GictYUG4JX8tUoY3yPi1ZTVpBPLV2WDaY1VLvhWyTX9QHj72A6mRRTSfXx--pCRY3MD7rrqhQyR7--GnByxHZDHQT1gajBP4QFgw== ./bin/rails assets:precompile --manifest=false || true

# Final stage for app image
FROM base

# Install packages needed for deployment, including Node.js for ExecJS
RUN apt-get update -qq \
    && apt-get install --no-install-recommends -y curl libsqlite3-0 libvips libpq5 nodejs \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN useradd rails --create-home --shell /bin/bash \
    && chown -R rails:rails db log storage tmp

USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]
