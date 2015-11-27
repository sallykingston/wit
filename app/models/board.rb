class Board < ActiveRecord::Base
  has_many :topics
  
  validates :title, :description, presence: true
end
