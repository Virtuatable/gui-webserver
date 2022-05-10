FROM ruby:3.0.0

WORKDIR /auth

COPY . /auth

# Installs dependencies to be able to start the server
RUN gem install bundler && bundle install
# Exposes the port of the rake application to the outside
EXPOSE 9292

ENTRYPOINT ["deployment/entrypoint.sh"]