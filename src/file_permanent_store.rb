require 'digest/sha2'

class FilePermanentStore
  def initialize(dir)
    @dir = dir
    load_keys
    @index_file = File.open "#{@dir}/index", 'w'
  end

  def store(key, value)
    File.write file_name(key), value

    @index_file.write "#{key}\n"
    @index_file.flush
    @keys[key] = 1
  end

  def retrieve(key)
    file_name = file_name(key)
    File.read file_name if File.exists? file_name
  end

  def keys
    @keys.keys
  end

  private

  def file_name(key)
    "#{@dir}/#{Digest::SHA1.hexdigest key}"
  end

  def load_keys
    index_file_name = "#{@dir}/index"
    @keys = Hash.new

    if File.exists? index_file_name
      File.open(index_file_name).each_line do |line|
        @keys[line.strip] = true
      end
    end
  end
end
