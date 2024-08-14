class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    listings.where.not(id: Reservation.where("checkin <= ? AND checkout >= ?", end_date, start_date).select(:listing_id))
  end

  def self.highest_ratio_res_to_listings
    City.joins(listings: :reservations)
        .select("cities.*, AVG(count(reservations.id)) OVER (PARTITION BY cities.id) AS avg_reservations_per_listing")
        .group('cities.id')
        .order('avg_reservations_per_listing DESC')
        .first
  end

  def self.most_res
    City.joins(listings: :reservations)
        .select("cities.*, COUNT(reservations.id) AS reservations_count")
        .group("cities.id")
        .order("reservations_count DESC")
        .first
  end
end

