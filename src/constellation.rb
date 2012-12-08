require_relative './processor.rb'
require_relative './world.rb'

# Define world
@world = eval(File.read("/home/chris/prog/constellation/data/s.rb"))

#@player.location = @world.create_room("Entrance", "This is the entrance", "This is the entrace to the game.\nIt has a second line because it's longer.")
#@player.location.north = @world.create_room("Hallway", "This is the hallway", "This is the hallway longer description")
#@world.get_room(1).south = @player.location

@player = @world.create_character("Player", "The player.", "This is the player.")
@player.move_to(@world.get_room(0))

# Define commands
@cmd = Processor.new

def move(direction)
  if @player.move direction
    @cmd.process("look")
  else
    puts "You can't go that way!"
  end
end

@cmd.add_command :look, lambda { |t|
    puts("#{@player.location.name}\n\n#{@player.location.long_desc}\n\n")
  }
@cmd.add_alias :l, :look

@cmd.add_command :north, lambda { |t|
    move :north
  }
@cmd.add_alias :n, :north

@cmd.add_command :south, lambda { |t|
    move :south
  }
@cmd.add_alias :s, :south

@cmd.add_command :west, lambda { |t|
    move :west
  }
@cmd.add_alias :w, :west

@cmd.add_command :east, lambda { |t|
    move :east
  }
@cmd.add_alias :e, :east

@cmd.add_command :up, lambda { |t|
    move :up
  }
@cmd.add_alias :u, :up

@cmd.add_command :down, lambda { |t|
    move :down
  }
@cmd.add_alias :d, :down

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
