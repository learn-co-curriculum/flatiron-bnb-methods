class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, through: :neighborhoods

  def city_openings(start_date, end_date)
    listings.where.not(id: Reservation.select(:listing_id)
      .where('checkin < ? AND checkout > ?', end_date, start_date))
  end

  def self.highest_ratio_res_to_listings
    City.all.max_by do |city|
      listings_count = city.listings.count
      reservations_count = city.listings.joins(:reservations).count
      reservations_count / listings_count
    end
  end

  def self.most_res
    City.all.max_by { |city| city.listings.joins(:reservations).count }
  end
end
