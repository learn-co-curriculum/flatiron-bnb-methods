class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood_id, presence: true


  before_create :make_host
  after_destroy :not_host

  def average_review_rating
    total_ratings = 0
    review_count = 0

    self.reviews.each do |review|
      total_ratings += review.rating
      review_count += 1
    end
    total_ratings.to_f / review_count
  end

  private

  def make_host
    self.host.update(host: true)
  end

  def not_host
    if self.host.listings.count == 0
      self.host.update(host: false)
    end
  end
end
