require 'rspec'
require_relative '../src/lru_cache'

RSpec.describe 'LRUCache' do
  before(:each) do
    @storage = double('storage')
    @cache = LRUCache.new @storage, :max_cache_size => 15
  end

  it 'should store all values in storage' do
    expect(@storage).to receive(:store).once.with('a', '1')
    expect(@storage).to receive(:store).once.with('b', '2')

    @cache.put 'a', '1'
    @cache.put 'b', '2'
  end

  it 'should not read from storage when values are cached' do
    allow(@storage).to receive(:store).once
    expect(@storage).to receive(:retrieve).never
    @cache.put 'a', '1'

    expect(@cache.get 'a').to eq('1')
  end

  it 'should retrieve unknown entries from storage only once' do
    expect(@storage).to receive(:retrieve).once.with('key').and_return('val')

    expect(@cache.get 'key').to eq('val')
    expect(@cache.get 'key').to eq('val')
  end

  it 'should keep sum of used memory under a limit' do
    allow(@storage).to receive(:store)

    @cache = LRUCache.new @storage, :max_cache_size => 16
    @cache.put 'a', ' ' * 8
    @cache.put 'b', ' ' * 7
    @cache.put 'a', ' ' * 10
    expect(@storage).to receive(:retrieve).with('b').and_return(' ' * 7)
    @cache.get 'b'
  end

  it 'should keep the most recently read items' do
    allow(@storage).to receive(:store)

    @cache = LRUCache.new @storage, :max_cache_size => 16
    @cache.put 'a', ' ' * 8
    @cache.put 'b', ' ' * 7
    @cache.get 'a'
    @cache.put 'c', ' ' * 10
    expect(@storage).to receive(:retrieve).with('a').and_return(' ' * 8)
    @cache.get 'a'
  end
end
