require 'sinatra'
require 'fileutils'
require 'json'

require_relative 'log_store'

post "/logs/*" do
  path = params[:splat][0]
  data = request.body.read

  LogStore.instance.append path, data
  ''
end

get "/logs/*" do
  path = params[:splat][0]

  log = LogStore.instance.get path

  if log == nil
    status 404
    'Entry not found!'
  else
    headers "Content-Type" => "text/plain; charset=utf8"
    log
  end
end

get '/*' do
  redirect '/logs/'
end
