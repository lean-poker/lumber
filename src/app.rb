require 'sinatra'
require 'fileutils'
require 'json'

require_relative 'log_store'
require_relative 'zlib_compressor'
require_relative 'lru_cache'
require_relative 'file_permanent_store'

configure do
  log_dir = "#{__dir__}/../logs"
  FileUtils.mkpath log_dir
  lru_cache = LRUCache.new FilePermanentStore.new(log_dir)

  LogStore.new_instance ZlibCompressor.new, lru_cache
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
