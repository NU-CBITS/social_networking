SocialNetworking::Engine.routes.draw do
  # client interfaces
  resources :profiles, only: [:show, :index]

  get "/profile_page", to: "profile_pages#show", as: :social_networking_profile
  get "/profile_page/:id", to: "profile_pages#show", as: :social_networking_profile_with_id
  get "/profiles_page", to: "profile_pages#index", as: :social_networking_profiles
  get "/goal_tool", to: "goals#tool", as: :social_networking_goals
  get "/group_goals", to: "goals#group", as: :social_networking_group_goals

  # server api
  resources :participants, only: [:index, :show]
  resources :nudges, only: [:create, :index]
  resources :on_the_mind_statements, only: :create
  resources :goals, only: [:index, :create]
  post "goals/:id", to: "goals#update", as: :goal
  resource :home, only: :show
  resources :profile_answers, only: [:index, :show, :create]
  post "profile_answers/:id", to: "profile_answers#update"
  resources :comments, only: :create
  resources :likes, only: :create
  get "/templates/:path.html" => "templates#page", constraints: { path: /.+/  }
  post "profiles/:profile_id/profile_icon_name/:icon_name", to: "profile_icon#save"
end
