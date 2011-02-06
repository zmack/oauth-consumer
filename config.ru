require 'yaml'
CONFIG = YAML.load_file('config.yml')

require File.expand_path('consumer.rb')
require File.expand_path('consumer2.rb')


map "/oauth" do
  run Consumer
end

map "/oauth2" do
  run Consumer2
end
