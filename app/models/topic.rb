class Topic < ActiveRecord::Base
  belongs_to :user
  belongs_to :board
  has_many :comments, as: :commentable

  validates :user_id, :board_id, :title, :content, presence: true
end
