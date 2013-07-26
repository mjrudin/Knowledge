class User < ActiveRecord::Base
  attr_accessible :password, :session_token, :username

  has_many :cats

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true
end
