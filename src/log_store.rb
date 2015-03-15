
class LogStore
  def initialize
    @values = Hash.new ''
  end

  def get(key)
    @values.has_key?(key.to_s) ? @values[key.to_s] : nil
  end

  def put(key, value)
    @values[key.to_s] = value
  end

  def append(key, value)
    @values[key.to_s] += value
  end
end
