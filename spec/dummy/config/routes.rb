Rails.application.routes.draw do
  mount SocialNetworking::Engine => "/social_networking"
  namespace :social_networking do
    get "/goal_tool", to: "goals#tool", as: :social_networking_goals
  end

  mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)

  root 'homes#show'
end
