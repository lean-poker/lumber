require_relative 'src/app'

map '/' do
  run Sinatra::Application
end