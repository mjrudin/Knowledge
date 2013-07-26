# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string(255)      not null
#  password_digest :string(255)      not null
#  session_token   :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require "BCrypt"
class User < ActiveRecord::Base
  attr_accessible :password, :username

  validates :username, :password_digest, :presence => true

  has_many :owned_photos, :class_name => "Photo", :foreign_key => :owner_id
  has_many :tags
  has_many :photos, :through => :tags, :source => :photo
  has_many :friendships, :foreign_key => :friender_id
  has_many :followers, :class_name => "Friendship", :foreign_key => :friendee_id

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end
end
