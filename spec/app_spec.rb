require 'rspec'
require 'rack/mock'
require_relative '../src/app'

RSpec.describe 'App' do
  before :each do
    LogStore.new_instance
    @client = Rack::MockRequest.new Sinatra::Application
  end

  def post_log(path, data)
    # Sinatra parses Content-Type-less and form-encoded POST bodies as request
    # params before the route runs, so raw bodies must use another content type.
    @client.post "/logs/#{path}", :input => data, 'CONTENT_TYPE' => 'text/plain'
  end

  it 'should store posted log entries' do
    response = post_log 'testapp', 'first entry'

    expect(response.status).to eq(200)
    expect(response.body).to eq('')
    expect(LogStore.instance.list('testapp').length).to eq(1)
  end

  it 'should append subsequent entries to the same rotation bucket' do
    post_log 'testapp', 'first'
    post_log 'testapp', ' second'

    content = LogStore.instance.list('testapp').map { |bucket| LogStore.instance.get "testapp/#{bucket}" }.join
    expect(content).to eq('first second')
  end

  it 'should list stored logs' do
    post_log 'testapp', 'entry'
    bucket = LogStore.instance.list('testapp').first

    response = @client.get '/logs/testapp'

    expect(response.status).to eq(200)
    expect(response.body).to include(%Q(href="/logs/testapp/#{bucket}"))
  end

  it 'should serve the raw content of a log entry' do
    post_log 'testapp', 'raw entry'
    bucket = LogStore.instance.list('testapp').first

    response = @client.get "/logs/testapp/#{bucket}"

    expect(response.status).to eq(200)
    expect(response.headers['Content-Type']).to include('text/plain')
    expect(response.body).to eq('raw entry')
  end

  it 'should respond 404 when there is nothing under the path' do
    response = @client.get '/logs/non-existing'

    expect(response.status).to eq(404)
    expect(response.body).to eq('Entry not found!')
  end

  it 'should redirect unknown paths to the log listing' do
    response = @client.get '/somewhere-else'

    expect(response.status).to eq(302)
    expect(response.headers['Location']).to end_with('/logs/')
  end
end
