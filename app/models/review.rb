class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, presence: true
  validates :description, presence: true
  validate :reservation_and_checkout_occured

  private

  def reservation_and_checkout_occured
    if reservation.blank? || reservation.status != "accepted" || reservation.checkout >= Date.today
      errors.add(:base, "Can't make a review unless the reservation was accepted and checkout has occurred.")
    end
  end
end
