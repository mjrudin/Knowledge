# == Schema Information
#
# Table name: friendships
#
#  id          :integer          not null, primary key
#  friender_id :integer
#  friendee_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Friendship < ActiveRecord::Base
  attr_accessible :friender_id, :friendee_id
  
  validates :friender_id, :presence => true
  belongs_to :friender, :class_name => "User"
  belongs_to :friendee, :class_name => "User"
  
  def as_json(options={})
    super(options.merge(:include => [:friender, :friendee]))
  end
end
