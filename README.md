# SocialNetworking

Server and client components for social networking functionality.

## Assumptions

This engine expects there to be a Devise-like API available, and an
authenticatable Participant class.

## Installation

Add to your `Gemfile`

    gem 'social_networking', git: 'git://github.com/cbitstech/social_networking.git'

Then

    bundle install

Add the migrations

    rake social_networking:install:migrations

And run them

    rake db:migrate

## Usage

Mount the engine in `config/routes.rb`

    mount SocialNetworking::Engine, at: "social_networking"

## Run Ruby specs

    rake spec

## Run JavaScript specs

    rake js_spec

## Run rubocop (Ruby linter)

    rake rubocop

## Run JSHint

    rake jshint
