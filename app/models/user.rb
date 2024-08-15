class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :guests, :class_name => "User", through: :reservations

  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def hosts
    User.joins(listings: { reservations: :guest })
        .where(reservations: { guest_id: id })
        .distinct
  end

  def host_reviews
    Review.joins(:reservation)
          .where(reservations: { listing_id: listings.pluck(:id) })
          .distinct
  end
end
