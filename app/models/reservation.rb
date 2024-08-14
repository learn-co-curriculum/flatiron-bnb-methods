class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :invalid_same_ids
  validate :check_availability
  validate :checkin_before_checkout
  validate :same_checkin_checkout
  
  def duration
    checkout - checkin
  end

  def total_price
    listing.price * duration
  end

  private

  def invalid_same_ids
    if self.guest_id == listing.host_id
      errors.add(:guest_id, "cannot be the same as the host's id")
    end
  end

  def check_availability
    overlapping_reservations = Reservation.where(listing_id: listing_id)
                                          .where.not(id: id)
                                          .where("NOT (checkout <= ? OR checkin >= ?)", checkin, checkout)

    if overlapping_reservations.exists?
      errors.add(:checkin, "Listing is not available on the selected check-in date.")
    end
  end

  def checkin_before_checkout
    return unless checkin && checkout
    if checkin > checkout
      errors.add(:checkin, "Checkin can't be after checkout")
    end
  end

  def same_checkin_checkout
    return unless checkin && checkout
    if checkin == checkout
      errors.add(:checkin, "Checkin & Checkout can't be the same")
    end
  end
end
