class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review


  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :invalid_same_ids
  validate :check_availability
  validate :invalid_checkout_before_checkin
  validate :invalid_same_checkout_checkin

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    duration * listing.price
  end
  private

  def invalid_same_ids
   if listing.host_id == guest_id
    errors.add(:guest_id, "NO")
   end
  end

  def invalid_checkin

  end

  def check_availability
    overlapping_reservations = listing.reservations.where.not(id: id)
      .where('checkin < ? AND checkout > ?', checkout, checkin)

    if overlapping_reservations.exists?
      errors.add(:base, 'The listing is not available for the selected dates')
    end
  end

  def invalid_checkout_before_checkin
    if checkout && checkin && checkout < checkin
      errors.add(:checkout, 'NO')
    end
  end

  def invalid_same_checkout_checkin
    if checkout && checkin && checkout == checkin
      errors.add(:checkout, 'NO')
    end
  end
end
