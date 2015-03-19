require 'rspec'
require_relative '../src/file_permanent_store'

RSpec.describe 'FilePermanentStore' do
  before :each do
    @temp_dir = Dir.mktmpdir
    @store = FilePermanentStore.new @temp_dir
  end

  after :each do
    FileUtils.remove_entry_secure @temp_dir, true
  end

  it 'should store values' do
    @store.store 'a', 'value'

    expect(@store.retrieve 'a').to eq('value')
  end

  it 'should return nil for non-existing keys' do
    expect(@store.retrieve 'non-existing').to eq(nil)
  end

  it 'should be able to enumerate and retrieve all existing keys' do
    @store.store 'old-key', 'old-value'
    @store.store 'old-key', 'another-old-value'

    new_store = FilePermanentStore.new @temp_dir
    new_store.store 'new-key', 'new-value'

    expect(new_store.keys).to eq(%w(old-key new-key))
    expect(new_store.retrieve 'old-key').to eq('another-old-value')
  end
end