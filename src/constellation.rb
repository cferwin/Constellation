require_relative './processor.rb'
require_relative './world.rb'

# Define world
@world = World.new

@room = @world.create_room("Entrance", "This is the entrance", "This is the entrace to the game.\nIt has a second line because it's longer.")
@room.north = @world.create_room("Hallway", "This is the hallway", "This is the hallway longer description")
@world.get_room(1).south = @room

@room = @world.get_room(0)

# Define commands
@cmd = Processor.new

@cmd.add_command :look, lambda { |t|
    puts("#{@room.name}\n\n#{@room.long_desc}\n\n")
  }
@cmd.add_alias :l, :look

@cmd.add_command :north, lambda { |t|
    @room = @room.north
    @cmd.process("look")
  }
@cmd.add_alias :n, :north

@cmd.add_command :south, lambda { |t|
    @room = @room.south
    @cmd.process("look")
  }
@cmd.add_alias :s, :south

@cmd.add_command :quit, lambda { |t| exit }
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
