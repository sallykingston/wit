Rails.application.config.middleware.use OmniAuth::Builder do

  if Rails.env.development? || Rails.env.test?
    provider :meetup, ENV['DEV_MEETUP_KEY'], ENV['DEV_MEETUP_SECRET']
  end

  if Rails.env.production?
    provider :meetup, ENV['MEETUP_KEY'], ENV['MEETUP_SECRET']
  end

end
