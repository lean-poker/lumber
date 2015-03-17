require 'sinatra'
require 'fileutils'
require 'json'

require_relative 'log_store'
require_relative 'zlib_compressor'

configure do
  LogStore.instance.compressor = ZlibCompressor.new
end

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
    list = LogStore.instance.list path

    if list.length > 0
      headers 'Content-Type' => 'text/html; charset=utf8'
      erb :list, :locals => {
              :path => (path.length == 0 or path.end_with?('/')) ? path : "#{path}/",
              :items => list
          }
    else
      status 404
      'Entry not found!'
    end
  else
    headers 'Content-Type' => 'text/plain; charset=utf8'
    log
  end
end

get '/*' do
  redirect '/logs/'
end
