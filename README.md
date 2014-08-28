# SocialNetworking

Server and client components for social networking functionality.

## Installation

Add to your `Gemfile`

    gem 'social_networking', git: 'git://github.com/cbitstech/social_networking.git'

Then

    bundle install

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
