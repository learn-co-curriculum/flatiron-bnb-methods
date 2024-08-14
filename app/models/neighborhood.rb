class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
    listings.where.not(id: Reservation.select(:listing_id)
      .where('checkin < ? AND checkout > ?', end_date, start_date))
  end

  def self.highest_ratio_res_to_listings
    Neighborhood.all.max_by do |neighborhood|
      listings_count = neighborhood.listings.count
      reservations_count = neighborhood.listings.joins(:reservations).count
      listings_count.zero? ? 0 : (reservations_count.to_f / listings_count)
    end
  end

  def self.most_res
    Neighborhood.all.max_by { |neighborhood| neighborhood.listings.joins(:reservations).count }
  end
end
