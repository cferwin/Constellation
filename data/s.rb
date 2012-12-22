require File.join(File.dirname(__FILE__), './world.rb')
@world = World.new
@ret = {}


# SAVING ROOM 0::Entrance
# Room
@room = @world.create_room(0, "Entrance", "This is the entrance", "This is the entrace to the game.
It has a second line because it's longer.")
@room.id = 0

# Room 0 Items
@room.items << @world.create_item("i", "A test item", "A test item long desc")
@room.items << @world.create_item("i", "A test item", "A test item long desc")

# Room 0 Characters
@character = @world.create_character("Player", "The player.", "This is the player.")
@character.location = @world.get_room 0
@character.location.characters << @character
@ret.store :player, @character


# SAVING ROOM 1:north:Hallway
# Room
@room = @world.create_room(1, "Hallway", "This is the hallway", "This is the hallway longer description")
@room.id = 1
@room = @world.get_room 1
@room.exits[:south] = @world.get_room 0

# SAVING ROOM 6:east:Library
# Room
@room = @world.create_room(6, "Library", "This room has many bookshelves in it.", "There are many bookshelves in this room. The rows must be thirty feet long. There seems to be a space between one of the shelves and the floor.")
@room.id = 6
@room = @world.get_room 6
@room.exits[:west] = @world.get_room 1

# SAVING ROOM 7:below:Crawlspace
# Room
@room = @world.create_room(7, "Crawlspace", "A small space below the shelves.", "The air in this tiny space is dusty, but it smells of leather and old paper.")
@room.id = 7
@room = @world.get_room 7
@room.exits[:out] = @world.get_room 6

# SAVED ROOM 7
@room = @world.get_room 6
@room.exits[:below] = @world.get_room 7

# SAVED ROOM 6
@room = @world.get_room 1
@room.exits[:east] = @world.get_room 6

# SAVED ROOM 1
@room = @world.get_room 0
@room.exits[:north] = @world.get_room 1

# SAVING ROOM 2:west:West Gate
# Room
@room = @world.create_room(2, "West Gate", "This is the West Gate", "This is the West Gate.
It has a second line because it's longer.")
@room.id = 2
@room = @world.get_room 2
@room.exits[:east] = @world.get_room 0

# SAVED ROOM 2
@room = @world.get_room 0
@room.exits[:west] = @world.get_room 2

# SAVING ROOM 3:south:South Gate
# Room
@room = @world.create_room(3, "South Gate", "This is the South Gate", "This is the South Gate.
It has a second line because it's longer.")
@room.id = 3
@room = @world.get_room 3
@room.exits[:north] = @world.get_room 0

# SAVED ROOM 3
@room = @world.get_room 0
@room.exits[:south] = @world.get_room 3

# SAVING ROOM 4:east:East Gate
# Room
@room = @world.create_room(4, "East Gate", "This is the East Gate", "This is the East Gate.
It has a second line because it's longer.")
@room.id = 4

# Room 4 Items
@room.items << @world.create_item("Test Item", "A test item", "A test item long desc")
@room = @world.get_room 4
@room.exits[:west] = @world.get_room 0

# SAVING ROOM 5:east:Test Room

# Room
@room = @world.create_room(5, "Test Room
", "", "")
@room.id = 5
@room = @world.get_room 5
@room.exits[:west] = @world.get_room 4

# SAVED ROOM 5
@room = @world.get_room 4
@room.exits[:east] = @world.get_room 5

# SAVED ROOM 4
@room = @world.get_room 0
@room.exits[:east] = @world.get_room 4

# SAVED ROOM 0
@ret.store :world, @world
@ret
