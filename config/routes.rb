SocialNetworking::Engine.routes.draw do
  # client interfaces
  get "/profile", to: "application#profile", as: :social_networking_profile
  get "/profiles", to: "application#profiles", as: :social_networking_profiles
  get "/feed", to: "application#feed", as: :social_networking_feed
  get "/create_goal", to: "application#create_goal", as: :social_networking_create_goal

  # server api
  resources :nudges, only: :create
end
