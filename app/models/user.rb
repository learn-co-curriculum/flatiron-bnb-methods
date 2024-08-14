class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  
  def guests
    reservations.includes(:guest).map(&:guest)
  end

  def hosts
    trips.includes(listing: :host).map { |trip| trip.listing.host }
  end

  def host_reviews
    reservations.map { |x| x.review }
  end
end
