class SessionsController < ApplicationController
require 'net/http'

  def create
    auth = request.env["omniauth.auth"]
    acc_token = auth["credentials"]["token"]
    if verify_wit_membership(auth, acc_token)
      user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_oauth(auth)
      user.wit_member = true
      user.save
      session[:user_id] = user.id
      redirect_to root_url, :notice => "Signed in!"
    else
      redirect_to root_url, :notice => "womp womp"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end

  def verify_wit_membership(auth, token)
    uri = URI("https://api.meetup.com/2/members?group_id=16881012&member_id="+auth["uid"].to_s+"&key="+ENV['MY_MEETUP_KEY'])
    request = Net::HTTP.get(uri)
    if auth["provider"] == "meetup" && !request["results"].empty?
      true
    else
      false
    end
  end
end
