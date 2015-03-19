
class LogStore
  attr_accessor :compressor, :cache

  def initialize(compressor = nil, cache = nil)
    @values = Hash.new ''

    @compressor = compressor || LogStoreDefaultCompressor.new
    @cache = cache || LogStoreDefaultCache.new
  end

  def get(key)
    @values.has_key?(key.to_s) ? @compressor.decompress(@values[key.to_s]) : nil
  end

  def put(key, value)
    @values[key.to_s] = @compressor.compress(value)
  end

  def append(key, value)
    @values[key.to_s] = @compressor.compress(@compressor.decompress(@values[key.to_s]) + value)
  end

  def list(key = '')
    prefix = key.length == 0 ? '' : "#{key}/"
    @values.keys.select{ |k| k.start_with? prefix }.map do |k|
      rel_path = k.gsub(/^#{prefix}/, '')
      rel_path[0..(rel_path.index('/') || 0) - 1]
    end.sort.uniq
  end

  def self.instance
    @instance ||= LogStore.new
  end

  def self.new_instance(compressor = nil, cache = nil)
    @instance = LogStore.new compressor, cache
  end
end

class LogStoreDefaultCompressor
  def compress(value)
    value
  end

  def decompress(value)
    value
  end
end

class LogStoreDefaultCache
  def initialize
    @cache = Hash.new
  end

  def store(key, value)
    @cache[key] = value
  end

  def retrieve(key)
    return @cache[key] if @cache.has_key? key
    nil
  end
end
