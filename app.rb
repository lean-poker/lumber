require 'sinatra'
require 'fileutils'

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

