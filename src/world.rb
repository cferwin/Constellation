require_relative './processor'
require_relative './room'
require_relative './character'
require_relative './item'

class World
  attr_accessor :rooms, :characters, :items

  def initialize
    @rooms = {}
    @characters = {}
    @items = {}
    @max_room_id = 0
    @max_character_id = 0
    @max_item_id = 0
  end

  # Rooms
  def get_room(id)
    if rooms.has_key?(id)
      rooms[id]
    else
      nil
    end
  end

  def add_room(room)
    room.id = @max_room_id
    @rooms.store @max_room_id, room
    @max_room_id += 1

    return room.id
  end

  def remove_room(id)
    rooms.delete id
  end

  def create_room(name, short_desc, long_desc)
    get_room(add_room(Room.new(0, name, short_desc, long_desc)))
  end
  
  # Characters
  def get_character(id)
    if characters.has_key?(id)
      characters[id]
    else
      nil
    end
  end

  def add_character(character)
    character.id = @max_character_id
    @characters.store @max_character_id, character
    @max_character_id += 1

    return character.id
  end

  def remove_character(id)
    characters.delete id
  end

  def create_character(name, short_desc, long_desc)
    get_character(add_character(Character.new(0, name, short_desc, long_desc)))
  end

  # Items
  def get_item(id)
    if items.has_key?(id)
      items[id]
    else
      nil
    end
  end

  def add_item(item)
    item.id = @max_item_id
    @items.store @max_item_id, item
    @max_item_id += 1

    return item.id
  end

  def remove_item(id)
    @items.delete id
  end

  def create_item(name, short_desc, long_desc)
    get_item(add_item(Item.new(0, name, short_desc, long_desc)))
  end

  def save(path)
    @file = File.open(path, "w")
    @saved = []

    @file << "require File.join(File.dirname(__FILE__), 'src/world.rb')"
    @file << "\n"
    @file << "@world = World.new"

    @rooms.each do |id, room|
      unless @saved.include?(room.id)
        @file << "\n"
        @file << "# Room\n"
        @file << "@room = @world.create_room(\"#{room.name}\", \"#{room.short_desc}\", \"#{room.long_desc}\")\n"
        if room.south
          unless @saved.include?(room.south.id)
            @file << "@south = @world.create_room(\"#{room.south.name}\", \"#{room.south.short_desc}\", \"#{room.south.long_desc}\")\n"
            @file << "@room.south = @south\n"
            @file << "@south.north = @room\n"
            @saved << room.south.id
          end
        end

        if room.west
          unless @saved.include?(room.west.id)
            @file << "@west = @world.create_room(\"#{room.west.name}\", \"#{room.west.short_desc}\", \"#{room.west.long_desc}\")\n"
            @file << "@room.west = @west\n"
            @file << "@west.east = @room\n"
            @saved << room.west.id
          end
        end

        if room.east
          unless @saved.include?(room.east.id)
            @file << "@east = @world.create_room(\"#{room.east.name}\", \"#{room.east.short_desc}\", \"#{room.east.long_desc}\")\n"
            @file << "@room.east = @east\n"
            @file << "@east.west = @room\n"
            @saved << room.east.id
          end
        end

        if room.north
          unless @saved.include?(room.north.id)
            @file << "@north = @world.create_room(\"#{room.north.name}\", \"#{room.north.short_desc}\", \"#{room.north.long_desc}\")\n"
            @file << "@room.north = @north\n"
            @file << "@north.south = @room\n"
            @saved << room.north.id
          end
        end

        room.items.each do |item|
          @file << "@room.items << @world.create_item(\"#{item.name}\", \"#{item.short_desc}\", \"#{item.long_desc}\")\n"
        end

        @saved << room.id
      end
    end

    @file << "@world"
  end
end
