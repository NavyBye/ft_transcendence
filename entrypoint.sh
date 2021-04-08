#!/bin/bash
if [ ! -f /.initialized ]; then
bundle config set --local git.allow_insecure true
bundle install
npm install
rails db:create
rails db:migrate
touch /.initialized
fi
exec "$@"
