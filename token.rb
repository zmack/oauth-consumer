require 'dm-core'
require 'dm-migrations'
require 'oauth'

DataMapper.setup :default, "sqlite3:data.sqlite"

class Token
  SITE_TOKEN = 'PSNbpsHWqYW6kDon8VNSjYTMOX42aioY7eIKspfF'
  SITE_SECRET = 'DClgKis23X20mjVMx25ZcXCmP3dWKppy7r7XotpW'
  SITE = "http://localhost:3001"

  include DataMapper::Resource

  property :id, Serial
  property :token, String
  property :secret, String

  def request
    consumer = OAuth::Consumer.new(Token::SITE_TOKEN, Token::SITE_SECRET, :site => Token::SITE)
    access_token = OAuth::AccessToken.new(consumer, token, secret)
  end
end
