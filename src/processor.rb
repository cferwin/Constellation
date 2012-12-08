class Processor
  attr_reader :table

  def initialize
    @table = Hash.new
  end

  def process(line)
    line.strip!
    line = line.split(' ')
    command = line.first.to_sym

    if table.has_key?(command)
      line.delete_at(0)
      table[command].call(line)
    else
      raise "Could not find command #{command}"
    end
  end

  def add_command(key, func)
    @table.store key, func
  end

  def remove_command(key)
    table.delete key
  end
end
