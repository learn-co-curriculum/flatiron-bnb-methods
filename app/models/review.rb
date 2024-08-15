class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true
  validate :res_not_passed


  private

  def res_not_passed
    if !reservation || reservation.status != "accepted" || reservation.checkout > Date.today
      errors.add(:base, "Reservation must be accepted and checkout date cannot be in the future")
    end
  end
end
