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
  after_create :convert_to_host
  after_destroy :convert_to_user_if_all_destroyed

  def convert_to_host
    user = Listing.last.host
    user.update(host: true)
  end
  
  def convert_to_user_if_all_destroyed
    if !Listing.where(host_id: self.host_id).exists?
      user = User.find(self.host_id)
      user.update(host: false)
    end
  end

  def average_review_rating
    reviews.average(:rating)
  end
end
