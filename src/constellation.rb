require_relative './processor.rb'
require_relative './world.rb'

# Define world
@world = eval(File.read("/home/chris/prog/constellation/data/s.rb"))

#@player.location = @world.create_room("Entrance", "This is the entrance", "This is the entrace to the game.\nIt has a second line because it's longer.")
#@player.location.north = @world.create_room("Hallway", "This is the hallway", "This is the hallway longer description")
#@world.get_room(1).south = @player.location

@player = @world.create_character("Player", "The player.", "This is the player.")
@player.location = @world.get_room(0)

# Define commands
@cmd = Processor.new

@cmd.add_command :look, lambda { |t|
    puts("#{@player.location.name}\n\n#{@player.location.long_desc}\n\n")
  }
@cmd.add_alias :l, :look

@cmd.add_command :north, lambda { |t|
    @player.location = @player.location.north
    @cmd.process("look")
  }
@cmd.add_alias :n, :north

@cmd.add_command :south, lambda { |t|
    @player.location = @player.location.south
    @cmd.process("look")
  }
@cmd.add_alias :s, :south

@cmd.add_command :west, lambda { |t|
    @player.location = @player.location.west
    @cmd.process("look")
  }
@cmd.add_alias :w, :west

@cmd.add_command :east, lambda { |t|
    @player.location = @player.location.east
    @cmd.process("look")
  }
@cmd.add_alias :e, :east

@cmd.add_command :quit, lambda { |t| @world.save(File.join(File.dirname(__FILE__), "../data/s.rb")) and exit }
@cmd.add_alias :q, :quit

while true do
  STDOUT << "> "
  @line = gets.chomp
  #@line = STDIN.readline

  begin
    @cmd.process @line
  rescue RuntimeError
    puts "Command Unknown"
  end
end
