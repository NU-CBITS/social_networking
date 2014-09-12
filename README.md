# SocialNetworking

Server and client components for social networking functionality.

## Assumptions

This engine expects there to be a Devise-like API available, and an
authenticatable `Participant` class stored in a `participants` table.

## Installation

Add to your `Gemfile`

    gem 'social_networking', git: 'git://github.com/cbitstech/social_networking.git'

Then

    bundle install

Add the migrations and run them

    rake social_networking:install:migrations db:migrate

Install PhantomJS

    Download: http://phantomjs.org/download.html
    Add the unzipped /bin folder to your $PATH:
    ---
    export PHANTOM_JS=$HOME_DIR/tools/phantomjs-1.9.7-linux-x86_64/bin/
    PATH=$PATH:$PHANTOM_JS
    ---

## Usage

Mount the engine in `config/routes.rb`

    mount SocialNetworking::Engine, at: "social_networking"

Include the JavaScript in your manifest

    //= require social_networking

## Run Ruby specs

Create the database

    rake app:db:create app:db:migrate

Run the specs

    rake spec

## Run JavaScript specs

    rake js_spec

## Run rubocop (Ruby linter)

    rake rubocop

## Run JSHint

    rake jshint

## Development

Note that when updating Angular, it is necessary to update
`spec/javascripts/helpers/angular-mocks.js`.
