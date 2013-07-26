class Favorite < ActiveRecord::Base
  attr_accessible :user_id, :contact_id
  belongs_to :user
  belongs_to :contact

  validates :user, :contact, presence: true
  validates_uniqueness_of :contact_id, :scope => :user_id

  def self.find_by_user_and_contact_id(user_id, contact_id)
    Favorite.where({user_id: user_id, contact_id: contact_id})
  end
end
