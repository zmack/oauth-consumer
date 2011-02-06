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

map "/" do
  run(Object.new.tap do |o|
    o.singleton_class.send(:define_method, :call) do |env|
      [ 200, { 'Content-Type' => 'text/html' }, File.open('index.html') ]
    end
  end)
end
