class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

  # Returns all of the available apartments in a neighborhood, given the date range
  def neighborhood_openings(start_date, end_date)
<<<<<<< HEAD
    date_range = (Date.parse(start_date)..Date.parse(end_date))
    listings.collect do |listing|
      available = true
      listing.booked_dates.each do |date|
          if date_range === date
            available = false
          end
=======
    parsed_start = Date.parse(start_date)
    parsed_end = Date.parse(end_date)
    openings = []
    listings.each do |listing|
      blocked = listing.reservations.any? do |r|
        parsed_start.between?(r.checkin, r.checkout) || parsed_end.between?(r.checkin, r.checkout)
      end
      unless blocked
        openings << listing
>>>>>>> solution
      end
      listing if available
    end
    return openings
  end

  def ratio_res_to_listings
    if listings.count > 0
      reservations.count.to_f / listings.count.to_f
    else
      0
    end
  end


  # Returns nabe with highest ratio of reservations to listings
  def self.highest_ratio_res_to_listings
    highest = self.first
    self.all.each do |neighborhood|
      if neighborhood.ratio_res_to_listings > highest.ratio_res_to_listings
        highest = neighborhood
      end
    end
    highest
  end

  # Returns nabe with most reservations
  def self.most_res
    most_reservations = self.first
    self.all.each do |neighborhood|
      if neighborhood.reservations.count > most_reservations.reservations.count
        most_reservations = neighborhood
      end
    end
    most_reservations
  end
  
end
