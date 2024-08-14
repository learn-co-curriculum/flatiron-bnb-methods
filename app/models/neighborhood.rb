class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
    listings.where.not(id: Reservation.where("checkin <= ? AND checkout >= ?", end_date, start_date).select(:listing_id))
  end

  def self.highest_ratio_res_to_listings
    Neighborhood.joins(listings: :reservations)
        .select("neighborhoods.*, AVG(count(reservations.id)) OVER (PARTITION BY neighborhoods.id) AS avg_reservations_per_listing")
        .group('neighborhoods.id')
        .order('avg_reservations_per_listing DESC')
        .first
  end

  def self.most_res
    Neighborhood.joins(listings: :reservations)
        .select("neighborhoods.*, COUNT(reservations.id) AS reservations_count")
        .group("neighborhoods.id")
        .order("reservations_count DESC")
        .first
  end
end
