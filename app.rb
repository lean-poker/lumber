require 'sinatra'
require 'fileutils'
require 'json'

require_relative 'bootstrap'

post "/api/tournament/:tournament_id/team/:repo_name/log" do
  timestamp = t.strftime("%Y%m%d%M")
  directory = "logs/#{params['tournament_id']}/#{params[:repo_name]}/"
  filename = directory + "#{timestamp.log}"
  data = request.body.read

  FileUtils.mkdir_p directory
  open(filename, 'a') do |f|
    f.write data
  end
end

get "/api/tournament/:tournament_id/team/:repo_name/log" do
  JSON.generate Dir["logs/#{params['tournament_id']}/#{params[:repo_name]}/"]
end

get "/api/tournament/:tournament_id/team/:repo_name/log/:filename" do
  directory = "logs/#{params['tournament_id']}/#{params[:repo_name]}/"
  filename = directory + "#{params[:filename]}"
  File.read(filename)
end