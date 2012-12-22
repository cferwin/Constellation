require_relative './processor.rb'
require_relative './world.rb'
require 'smart_colored/extend'

# Load the world
@world = nil
if ARGV.size == 1
  @path = ARGV.first
  @file = eval(File.read(File.join(File.dirname(__FILE__), @path)))
  @world = @file[:world]
  @player = @file[:player]
else
  puts "WARNING: Enter a valid path to a save file.".red.bold
  puts
  while @world.nil?
    print "> ".red.bold
    @path = $stdin.gets.chomp
    begin
      @file = eval(File.read(File.join(File.dirname(__FILE__), path)))
      @world = @file[:world]
      @player = @file[:player]
      @player.player = true
    rescue
      puts "Could not find a file at #{@path}".red.bold
    end
  end
end

puts
puts "Loaded game from #{@path}".green.bold

# Define command processor
@cmd = instance_eval(File.read(File.join(File.dirname(__FILE__), "commands.rb")))
@cmd.world = @world
@cmd.player = @player

def expand_direction(direction)
  case direction
    when :n
      direction = :north
    when :s
      direction = :south
    when :e
      direction = :east
    when :w
      direction = :west
    when :u
      direction = :up
    when :d
      direction = :down
  end

  direction
end

# To display "can't go..." message when the @player is using a standard direction
def is_direction(direction)
  if [:north, :south, :east, :west, :up, :down].include?(expand_direction(direction))
    direction
  else
    nil
  end
end

def move(direction)
  if @player.move(expand_direction(direction))
    @cmd.process("look")
    @player.location
  else
    puts "You can't go that way!"
    nil
  end
end

while true do
  print "> "
  @line = $stdin.gets.chomp

  begin
    @cmd.process @line
  rescue RuntimeError
    if @player.location.get_exit(expand_direction(@line.to_sym)) || is_direction(expand_direction(@line.to_sym))
      move @line.to_sym
    else
      puts "Command Unknown"
    end
  end
end
