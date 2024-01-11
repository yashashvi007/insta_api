Rails.application.routes.draw do
  resources :posts

  get '/member_details' => 'members#index'
  post "toggle_like", to: 'likes#toggle_like'
  post "/follow/:user_id" , to: 'follower#follow'
  get "/follow/waiting_requests" , to: "follower#waiting_recieved_requests"
  post "/unfollow/:user_id" , to: "follower#unfollow"
  post "/cancel_request/:user_id", to: "follower#cancel_request"
  post "/accept_request/:follow_id" , to: "follower#accept_follow"
  get "/my_followers", to: "follower#followers"

  devise_for :users, controllers: {
    sessions: 'users/sessions', 
    registrations: 'users/registrations'
  }

  resources :comments, only: [:create , :destroy]
end
