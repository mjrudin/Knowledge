class User < ActiveRecord::Base
  attr_accessible :email, :name, :token

  has_many :contacts
  has_many :favorites
  has_many :favorite_contacts, :through => :favorites, :source => :contact

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, 
    format: { with: VALID_EMAIL_REGEX }
  validates :name, presence: true
end
