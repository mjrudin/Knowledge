class Contact < ActiveRecord::Base
  attr_accessible :address, :email, :name, :phone_number

  belongs_to :user

  validates :user, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :name, presence: true
end
