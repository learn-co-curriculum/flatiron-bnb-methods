class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true

  validate :existing_elapsed_reservation

  def existing_elapsed_reservation
    if reservation.nil? || reservation.checkout >= Date.today || reservation.status != 'accepted'
      errors.add(:reservation, "try again")
    end
  end
end
