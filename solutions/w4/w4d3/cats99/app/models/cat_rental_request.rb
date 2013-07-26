class CatRentalRequest < ActiveRecord::Base
  attr_accessible :begin_date, :cat_id, :end_date, :status

  belongs_to :cat

  default_scope order('begin_date ASC')

  validates :begin_date, :end_date, :cat, presence: true
  validates :status, presence: true, 
    inclusion: { :in => ["undecided", "approved", "denied"] }
  validate :end_after_begin, :dates_not_overlap

  def approve
    self.status = 'approved'
    save
    overlapping_requests.update_all({status: "denied"}, "status = 'undecided'")
  end

  private

  def end_after_begin
    unless end_date > begin_date
      errors[:end_date] << "must be after the begin date"
    end
  end

  def dates_not_overlap
    if approved_overlapping_requests.count > 0
      errors[:begin_date] << "overlaps an existing approved request"
      errors[:end_date] << "overlaps an existing approved request"
    end
  end

  def overlapping_requests
    CatRentalRequest.where(cat_id: cat_id).
      where("NOT (begin_date > ? OR end_date < ?)", end_date, begin_date)
  end

  def approved_overlapping_requests
    overlapping_requests.where(status: "approved")
  end
end
