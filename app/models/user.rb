class User < ActiveRecord::Base
  def self.create_with_oauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      if user.provider == "meetup"
        user.photo = auth["info"]["photo_url"]
      end
    end
  end

  has_many :comments
  has_many :articles
  has_many :topics

  validates :provider, :uid, :name, presence: true
  validates :admin, exclusion: { in: [nil] }
end
