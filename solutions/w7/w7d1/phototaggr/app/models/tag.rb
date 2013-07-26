# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  photo_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Tag < ActiveRecord::Base
  attr_accessible :photo_id, :user_id
  belongs_to :photo
  belongs_to :user
  
  def as_json(options)
    super(options.merge(:include => :user))
  end
end
