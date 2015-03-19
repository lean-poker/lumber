require 'zlib'

class ZlibCompressor
  def compress(value)
    deflate = Zlib::Deflate.new
    compressed = deflate.deflate(value, Zlib::FULL_FLUSH)
    deflate.close

    compressed
  end

  def decompress(value)
    Zlib::Inflate.new.inflate(value)
  end
end
