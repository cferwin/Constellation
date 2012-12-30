class Processor
  attr_reader :table, :line
  attr_accessor :world, :player

  def initialize(&block)
    @table = Hash.new
    instance_eval(&block) if block
  end

  def process(line)
    line = line.split
    command = line.first

    if @table.has_key?(command)
      line.delete_at(0)
      @line = line  # The @line variable can be used in commands
      @table[command].call(line)
    else
      raise "Could not find command #{command}"
    end
  end

  # DSL functions
  def keyword(key, &block)
    unless block
      raise "Keyword requires a block of code to be run with the command."
    end

    add_command key, &block
  end

  def alias(short, long)
    add_alias(short, long)
  end

  # Regular interface functions
  def add_command(key, &func)
    @table.store key, func
  end

  def remove_command(key)
    @table.delete key
  end

  def add_alias(alias_key, command_key)
    if @table.has_key?(command_key)
      add_command(alias_key, &@table[command_key])
    end
  end

  def remove_alias(key)
    @table.delete key
  end
end
