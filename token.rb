require 'dm-core'
require 'dm-migrations'
DataMapper.setup :default, "sqlite3:data.sqlite"

class Token
  include DataMapper::Resource

  property :id, Serial
  property :token, String
  property :secret, String
  property :network, String
end
