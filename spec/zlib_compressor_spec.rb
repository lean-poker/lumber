require 'rspec'
require_relative '../src/zlib_compressor'

RSpec.describe do
  it 'should be able to compress and decompress' do
    compressor = ZlibCompressor.new
    value = 'this value is here to be compressed'

    compressed_value = compressor.compress(value)
    expect(compressed_value).not_to eq(value)
    expect(compressor.decompress compressed_value).to eq(value)
  end
end