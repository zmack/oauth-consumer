require 'dm-core'
require 'dm-migrations'
require 'dm-serializer'
require 'oauth'

DataMapper.setup :default, "sqlite3:data.sqlite"

class Token
  include DataMapper::Resource

  property :id, Serial
  property :token, String
  property :secret, String

  def request
    consumer = OAuth::Consumer.new(
      CONFIG['oauth']['token'],
      CONFIG['oauth']['secret'],
      :site => CONFIG['oauth']['site']
    )
    access_token = OAuth::AccessToken.new(consumer, token, secret)
  end
end
