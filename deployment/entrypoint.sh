#!/usr/bin/env bash

function web {
  # Installs the gem to use with the S3 script
  gem install aws-sdk-s3
  # Create the directory for the frontend
  mkdir -p public/gui
  # Clones the folder marked as "current" in the public/ directory
  ruby ./deployment/cloner.rb
  # Starts the application
  bundle exec puma
}

function shell {
  /bin/sh
}

case "$1" in
  "web")
  web
  ;;

  "shell")
  shell
  ;;
esac