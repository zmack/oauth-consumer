require 'rubygems'
require 'sinatra'
require 'oauth2'
require 'json'
require './token'

DataMapper.auto_upgrade!

class Consumer2 < Sinatra::Base
  def client
    OAuth2::Client.new(
      CONFIG['oauth2']['client_id'],
      CONFIG['oauth2']['secret'],
      :site => CONFIG['oauth2']['site'],
      :access_token_url => CONFIG['oauth2']['access_token_url'],
    )
  end

  get '/init' do
    redirect client.web_server.authorize_url(
      :redirect_uri => redirect_uri,
      :scope => 'email,offline_access'
    )
  end

  get '/callback' do
    access_token = client.web_server.get_access_token(params[:code], :redirect_uri => redirect_uri)
    user = JSON.parse(access_token.get('/api/v1/account/verify_credentials'))

    user.inspect
  end

  def redirect_uri
    uri = URI.parse(request.url)
    uri.path = '/oauth2/callback'
    uri.query = nil
    uri.to_s
  end
end
