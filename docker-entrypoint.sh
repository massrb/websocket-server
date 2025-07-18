#!/bin/bash
set -e

bundle exec rails db:migrate

# exec command from Dockerfile or command line
exec "$@"

