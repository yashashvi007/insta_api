class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :posts  
  has_many :likes  
  has_many :comments  


  # mujhe follow krne wali not accepted requests
  has_many :follow_requests, -> {where(accepted: false)}, class_name: "Follow", foreign_key: "followed_id"

  # mujhe follow krne ke liye aayi hui sari requests 
  has_many :recieved_requests, class_name: "Follow", foreign_key: "followed_id" 
  
  # isko decide krna hai 
  has_many :sent_requests, class_name: "Follow", foreign_key: "follower_id" 

  # mujhko aayi requests follow krne ke liye
  has_many :waiting_recieved_requests, -> {where(accepted: false)}, class_name: "Follow", foreign_key: "follower_id"

  # maeri bheji hui requests jo accept nhi hui hai 
  has_many :waiting_sent_requests , -> {where(accepted: false)}, class_name: "Follow", foreign_key: "followed_id"
  
  # meri accepted requests
  has_many :accepted_sent_requests, -> {where(accepted: true)}, class_name: "Follow", foreign_key: "follower_id"
  has_many :accepted_recieved_requests, -> {where(accepted: true)}, class_name: "Follow", foreign_key: "followed_id"

  has_many :followers, through: :accepted_recieved_requests , source: :follower
  has_many :followings, through: :accepted_sent_requests, source: :followed

  def jwt_payload
    super
  end

  def follow(user)
    Follow.create(follower: self, followed: user)
  end

  def unfollow(user)
     self.accepted_sent_requests.find_by(followed: user)&.destroy
  end

  def cancel_request(user)
    self.waiting_sent_requests.find_by(followed: user)&.destroy
  end
        
end
