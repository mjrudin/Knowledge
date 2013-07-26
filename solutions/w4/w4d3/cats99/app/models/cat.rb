class Cat < ActiveRecord::Base
  COLORS = ["Red", "Black", "White", "Blue", "Other"]

  attr_accessible :birthday, :color, :name, :user_id, :sex

  belongs_to :user
  has_many :cat_rental_requests, dependent: :destroy

  validates :birthday, :name, :user, presence: true
  validates :color, presence: true, inclusion: { :in => COLORS }
  validates :sex, presence: true, inclusion: { :in => ["Male", "Female"] }
end
