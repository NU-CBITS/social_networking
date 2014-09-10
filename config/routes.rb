SocialNetworking::Engine.routes.draw do
  # client interfaces
  get "/profile", to: "application#profile", as: :social_networking_profile
  get "/profiles", to: "application#profiles", as: :social_networking_profiles
  get "/feed", to: "application#feed", as: :social_networking_feed
  get "/goal_tool", to: "goals#tool", as: :social_networking_goals
  get "/group_goals", to: "goals#group", as: :social_networking_group_goals

  # server api
  resources :participants, only: [:index, :show]
  resources :nudges, only: :create
  resources :goals, only: [:index, :create]
  post "goals/:id", to: "goals#update", as: :goal
end
