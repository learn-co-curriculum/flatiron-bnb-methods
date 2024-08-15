class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings (start_date, end_date)
    available_listings = []

    listings.each do |listing|
      conflicts = false

      listing.reservations.each do |reservation|
        if dates_overlap?(start_date, end_date, reservation.checkin, reservation.checkout)
          conflicts = true
          break
        end
      end

      available_listings << listing unless conflicts
    end

    available_listings
  end

  def dates_overlap?(start_date1, end_date1, start_date2, end_date2)
    start_date1 = Date.parse(start_date1) if start_date1.is_a?(String)
    end_date1 = Date.parse(end_date1) if end_date1.is_a?(String)
    start_date2 = Date.parse(start_date2) if start_date2.is_a?(String)
    end_date2 = Date.parse(end_date2) if end_date2.is_a?(String)

    start_date1 <= end_date2 && start_date2 <= end_date1
  end

  def self.highest_ratio_res_to_listings
    Neighborhood.joins(:listings)
        .select('neighborhoods.*, COUNT(reservations.id) / COUNT(DISTINCT listings.id) AS ratio')
        .joins(listings: :reservations)
        .group('neighborhoods.id')
        .order('ratio DESC')
        .first
  end

  def self.most_res
    Neighborhood.joins(:reservations)
      .select('neighborhoods.*, COUNT(reservations.id) AS reservations_count')
      .group('neighborhoods.id')
      .order('reservations_count DESC')
      .first
  end
end
