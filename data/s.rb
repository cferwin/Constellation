require File.join(File.dirname(__FILE__), 'src/world.rb')
@world = World.new
# Room
@room = @world.create_room("Entrance", "This is the entrance", "This is the entrace to the game.
It has a second line because it's longer.")
@south = @world.create_room("South Gate", "This is the South Gate", "This is the South Gate longer description")
@room.south = @south
@south.north = @room
@west = @world.create_room("West Gate", "This is the West Gate", "This is the West Gate longer description")
@room.west = @west
@west.east = @room
@east = @world.create_room("East Gate", "This is the East Gate", "This is the East Gate longer description")
@room.east = @east
@east.west = @room
@north = @world.create_room("Hallway", "This is the hallway", "This is the hallway longer description")
@room.north = @north
@north.south = @room
@room.items << @world.create_item("Test Item", "A test item", "A test item long desc")
@room.items << @world.create_item("i", "A test item", "A test item long desc")
@world