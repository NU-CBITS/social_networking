Rails.application.routes.draw do
  mount SocialNetworking::Engine => "/social_networking"

  mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)

  root to: "profile#index"
end
