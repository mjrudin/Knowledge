# == Schema Information
#
# Table name: photos
#
#  id         :integer          not null, primary key
#  url        :text
#  owner_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Photo < ActiveRecord::Base
  attr_accessible :url
  
  belongs_to :owner, :class_name => "User"
  has_many :tags
  has_many :tagged_users, :through => :tags, :source => :user
end
