require 'rspec'
require_relative '../src/log_store'

RSpec.describe 'LogStore' do
  before :each do
    @store = LogStore.new
  end

  it 'should return nil if key is not matching' do
    expect(@store.get 'test.key').to eq(nil)
  end

  it 'should return value if it has been already set' do
    @store.put 'key.existing', 'value'
    expect(@store.get 'key.existing').to eq('value')
  end

  it 'should be able to append to an existing value' do
    @store.put 'key', 'value'
    @store.append 'key', ', another value'
    expect(@store.get 'key').to eq('value, another value')
  end

  it 'should not fail when appended without creating the key' do
    @store.append 'nonexisting', 'value'
    expect(@store.get 'nonexisting').to eq('value')
  end

  it 'should handle all type keys as strings' do
    @store.put :test_key, 'value'
    @store.append :test_key, '2'
    @store.put 'another_test_key', 'value'
    expect(@store.get 'test_key').to eq('value2')
    expect(@store.get :another_test_key).to eq('value')
  end
end
