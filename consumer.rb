require 'rubygems'
require './token'

require 'sinatra'
require 'oauth'

DataMapper.auto_upgrade!

class Consumer < Sinatra::Base
  site_token = CONFIG['oauth']['token']
  site_secret = CONFIG['oauth']['secret']

  enable :sessions

  get '/init' do
    consumer = OAuth::Consumer.new(site_token, site_secret, :site => CONFIG['oauth']['site'])
    req_token = consumer.get_request_token({ :oauth_callback => "http://#{request.host}:#{request.port}/oauth/callback"})

    session[:token] = req_token.token
    session[:secret] = req_token.secret

    redirect req_token.authorize_url
  end

  get '/callback' do
    oauth_token = params[:oauth_token]
    oauth_verifier = params[:oauth_verifier]

    consumer = OAuth::Consumer.new(site_token, site_secret, :site => CONFIG['oauth']['site'])

    req_token  = OAuth::RequestToken.new(consumer, oauth_token, session[:secret])
    access_token = req_token.get_access_token(:oauth_verifier => oauth_verifier)

    token = Token.create(:token => access_token.token, :secret => access_token.secret)
    token.request.get('/api/v1/account/verify_credentials').body
  end
end
