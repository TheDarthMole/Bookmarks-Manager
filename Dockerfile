FROM ruby:2.6.5-alpine3.11

# Install required dependencies
RUN apk add build-base openssl-dev git sqlite-dev
RUN gem install bundler

# Create the user to run the app
RUN addgroup bookmark_manager && adduser -D bookmark_manager -G bookmark_manager

# Copy over the server files and own them by the hosting user
COPY ./ /srv/bookmark_manager
WORKDIR /srv/bookmark_manager
RUN chown -R bookmark_manager: /srv/bookmark_manager

# Install the required gems
RUN bundle install

# Switch to the hosting user
USER bookmark_manager
WORKDIR /srv/bookmark_manager

# Open port 4567 and run the server
EXPOSE 4567
ENTRYPOINT ["/usr/local/bin/ruby", "/srv/bookmark_manager/startServer.rb"]

