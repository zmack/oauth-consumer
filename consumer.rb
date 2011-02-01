require 'rubygems'
require './token'

require 'sinatra'
require 'oauth'
require 'haml'

DataMapper.auto_upgrade!

class Consumer < Sinatra::Base
  site_token = 'PSNbpsHWqYW6kDon8VNSjYTMOX42aioY7eIKspfF'
  site_secret = 'DClgKis23X20mjVMx25ZcXCmP3dWKppy7r7XotpW'

  enable :sessions

  get '/init' do
    consumer = OAuth::Consumer.new(site_token, site_secret, :site => "http://localhost:3001")
    req_token = consumer.get_request_token({ :oauth_callback => "http://#{request.host}:#{request.port}/callback"})

    session[:token] = req_token.token
    session[:secret] = req_token.secret

    redirect req_token.authorize_url
  end

  get '/support' do
    tp = token.connection site_token, site_secret

    "This would be your lovely support page"
  end

  get '/embed' do
    access_token = params[:token]
    token = Token.first(:token => access_token)
  end

  get '/callback' do
    oauth_token = params[:oauth_token]
    oauth_verifier = params[:oauth_verifier]
    p site_token
    p site_secret

    consumer = OAuth::Consumer.new(site_token, site_secret, :site => "http://localhost:3001")

    p consumer
    req_token  = OAuth::RequestToken.new(consumer, oauth_token, session[:secret])
    p req_token
    access_token = req_token.get_access_token(:oauth_verifier => oauth_verifier)

    Token.create(:token => access_token.token, :secret => access_token.secret)
  end
end
