class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true

  validate :not_host
  validate :is_available?
  validate :checkin_after_checkout

  def not_host
    if listing.host_id == guest_id
      errors.add(:guest_id, "Cannot book own listing")
    end
  end

  def is_available?
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |reso|
      dates = reso.checkin..reso.checkout
      if dates === checkin || dates === checkout
        errors.add(:guest_id, "Currently booked")
      end
    end
  end

  def checkin_after_checkout
    if checkin && checkout && checkout <= checkin
      errors.add(:guest_id, "Gotta stay before you can leave")
    end
  end

  def duration
    days = checkout - checkin
    days.to_i
  end

  def total_price
    listing.price * duration
  end
end
