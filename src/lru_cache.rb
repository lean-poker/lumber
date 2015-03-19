
class LRUCache
  class Entry
    attr_reader :last_used, :value, :length

    def initialize(value)
      @value = value
      @length = value.length
      update
    end

    def update
      @last_used = Time.new.to_f
    end
  end

  def initialize(storage, options = {})
    @storage = storage
    @cache = Hash.new
    @cache_size = 0
    @max_cache_size = options[:max_cache_size] || 4*1024*1024
  end

  def put(key, value)
    @storage.store key, value

    entry = Entry.new value
    @cache[key] = entry
    @cache_size += entry.length
    collect_garbage
  end

  def get(key)
    if @cache.has_key? key
      entry = @cache[key]
      entry.update

      return entry.value
    end

    value = @storage.retrieve key

    if value
      entry = Entry.new value
      @cache[key] = entry
      entry.value
    end

    value
  end

  def keys
    @storage.keys
  end

  def has_key?(key)
    @storage.has_key? key
  end

  private

  def collect_garbage
    return if @cache_size < @max_cache_size

    @cache.to_a.sort{ |a, b| a[1].last_used <=> b[1].last_used }.to_h.each do |key, entry|
      @cache.delete key
      @cache_size -= entry.length

      break if @cache_size < @max_cache_size
    end
  end
end
