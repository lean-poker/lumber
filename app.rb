require 'sinatra'
require 'fileutils'
require 'json'

require_relative 'bootstrap'

post "/api/tournament/:tournament_id/team/:repo_name/log" do
  timestamp = Time.new.strftime("%Y%m%d%M")
  directory = "logs/#{params['tournament_id']}/#{params[:repo_name]}/"
  filename = directory + "#{timestamp}.log"
  data = request.body.read

  FileUtils.mkdir_p directory
  open(filename, 'a') do |f|
    f.write data
  end
  ''
end

get "/api/tournament/:tournament_id/team/:repo_name/log" do
  headers "Content-Type" => "text/plane; charset=utf8"
  files = Dir["logs/#{params['tournament_id']}/#{params[:repo_name]}/*"].sort_by { |x| File.mtime(x) }
  files.last(3).map do |filename|
    File.read(filename)
  end.join("\n")
end
