FROM ruby:2.6.5-alpine3.11

# Install required dependencies
RUN apk add build-base openssl-dev git sqlite-dev

# Copy over the server files
COPY ./ /srv/bookmark
WORKDIR /srv/bookmark

# Install the bundler and gems
RUN gem install bundler
RUN bundle install

# Show the docker IP
RUN ip a show eth0

# Open port 4567 and run the server
EXPOSE 4567
ENTRYPOINT ["/usr/local/bin/ruby", "/srv/bookmark/startServer.rb"]

