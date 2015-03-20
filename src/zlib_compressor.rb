require 'zlib'

class ZlibCompressor
  def compress(value)
    deflate = Zlib::Deflate.new
    compressed = deflate.deflate(value, Zlib::FINISH)
    deflate.close

    compressed
  end

  def decompress(value)
    return '' if value.length == 0

    inflate = Zlib::Inflate.new
    decompressed = inflate.inflate(value)
    inflate.finish
    inflate.close

    decompressed
  end
end
