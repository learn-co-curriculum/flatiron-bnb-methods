module Reservable
  extend ActiveSupport::Concern

  def openings(start_date, end_date)
    listings.
      joins("left outer join reservations on listings.id = reservations.listing_id").
      where(
        "reservations.check_in >= :end_date OR reservations.check_out <= :start_date OR (reservations.check_in is null AND reservations.check_out is null)",
        end_date: Date.parse(end_date),
        start_date: Date.parse(start_date)
      )
  end

  def ratio_reservations_to_listings
    if listings.count > 0
      reservations.count.to_f / listings.count.to_f
    end
  end

  class_methods do
    def highest_ratio_reservations_to_listings
      all.max do |a, b|
        a.ratio_reservations_to_listings <=> b.ratio_reservations_to_listings
      end
    end

    def most_reservations
      all.max do |a, b|
        a.reservations.count <=> b.reservations.count
      end
    end
  end
end
