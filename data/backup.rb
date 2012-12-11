require File.join(File.dirname(__FILE__), 'src/world.rb')
@world = World.new
@ret = {}


# SAVING ROOM 0
# Room
@room = @world.create_room("Entrance", "This is the entrance", "This is the entrace to the game.
It has a second line because it's longer.")

# Room 0 Items
@room.items << @world.create_item("i", "A test item", "A test item long desc")
@room.items << @world.create_item("i", "A test item", "A test item long desc")
@room.north = @world.create_room("Hallway", "This is the hallway", "This is the hallway longer description")
@room.north.south = @world.get_room 0
@room.west = @world.create_room("West Gate", "This is the West Gate", "This is the West Gate.
It has a second line because it's longer.")
@room.west.east = @world.get_room 0
@room.south = @world.create_room("South Gate", "This is the South Gate", "This is the South Gate.
It has a second line because it's longer.")
@room.south.north = @world.get_room 0
@room.east = @world.create_room("East Gate", "This is the East Gate", "This is the East Gate.
It has a second line because it's longer.")
@room.east.west = @world.get_room 0

# Room 4 Items
@room.east.items << @world.create_item("Test Item", "A test item", "A test item long desc")

# Room 4 Characters
@character = @world.create_character("Player", "The player.", "This is the player.")
@character.location = @world.get_room 4
@character.location.characters << @character
@ret.store :player, @character


# SAVED ROOM 0
@ret.store :world, @world
@ret
