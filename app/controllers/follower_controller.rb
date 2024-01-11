class FollowerController < ApplicationController 

  before_action :set_user , only: [:follow , :unfollow , :cancel_request]
  before_action :set_follow_request, only: [:accept_follow , :decline_follow]

  def waiting_recieved_requests 
    waiting_recieved_requests = current_user.waiting_recieved_requests 
    render json: {
      waiting_requests: waiting_recieved_requests
    }
  end

  def follow
    current_user.follow(@user)  
    render json: {
      message: "Request sent"
    }
  end

  def followers
    x= current_user.followers
    render json: {
      followers: x
    }
  end

  def unfollow
    current_user.unfollow(@user)
    render json: {
      message: "removed from followed"
    }
  end

  def cancel_request
    current_user.cancel_request(@user)
    x = current_user.waiting_recieved_requests 
    render json: {
      waiting_requests: x
    }
  end

  def accept_follow
    @follow_req.accept
    render json: {
      message: "accepted", 
      follow: @follow_req
    }
  end

  def decline_follow
    @follow_req.destroy 
    render json: {
      message: "declined"
    }
  end

  private 
  def set_user
    p params
    @user = User.find(params[:user_id])
  end

  def set_follow_request
    @follow_req = Follow.find(params[:follow_id])
  end
end 

