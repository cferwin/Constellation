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
    @saved = []
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
    file = File.open(path, "w")
    @saved = []

    file << "require File.join(File.dirname(__FILE__), 'src/world.rb')\n"
    file << "@world = World.new\n"
    file << "@ret = {}\n"

    @rooms.each do |id, room|
      unless @saved.include?(room.id)
        file << "\n"
        @saved << room.id
        file << save_room(room)
      end
    end

    file << "@ret.store :world, @world\n"
    file << "@ret\n"
  end

  private
  def save_room(room)
    file = String.new
    file << "\n# SAVING ROOM #{room.id}\n"
    file << "# Room\n"
    if @saved.include? room.id
      file << "@room = #{create_room_string room}\n"
    else
      file << "@room = @world.get_room #{room.id}\n"
      @saved << room.id
    end

    unless room.items.empty?
      file << "\n# Room #{room.id} Items\n"
      room.items.each do |item|
        file << "@room.items << #{create_item_string item}\n"
      end
    end

    unless room.characters.empty?
      file << "\n# Room #{room.id} Characters\n"
      room.characters.each do |character|
        file << "#{save_character(character)}\n"
      end
    end

    opposite = {north: :south, south: :north, west: :east, east: :west}
    {north: room.north, west: room.west, south: room.south, east: room.east}.each do |dir, obj|
      if obj
        unless @saved.include? obj.id
          file << "@room.#{dir} = #{create_room_string obj}\n"
          file << "@room.#{dir}.#{opposite[dir]} = @world.get_room #{room.id}\n"
          unless obj.items.empty?
            file << "\n# Room #{obj.id} Items\n"
            obj.items.each do |item|
              file << "@room.#{dir}.items << #{create_item_string item}\n"
            end
          end

          unless obj.characters.empty?
            file << "\n# Room #{obj.id} Characters\n"
            obj.characters.each do |character|
              file << "#{save_character(character)}\n"
            end
          end
          @saved << obj.id
        else
          file << "@room.#{dir} = @world.get_room #{obj.id}\n"
          file << "@room.#{dir}.#{opposite[dir]} = @world.get_room @room.id\n"
          file << "@room = @world.get_room #{room.id}\n"
        end
      end
    end

    file << "\n# SAVED ROOM #{room.id}\n"
    file
  end

  def create_room_string(room)
    "@world.create_room(\"#{room.name}\", \"#{room.short_desc}\", \"#{room.long_desc}\")"
  end

  def save_character(character)
    file = String.new
    file << "@character = @world.create_character(\"#{character.name}\", \"#{character.short_desc}\", \"#{character.long_desc}\")\n"
    file << "@character.location = @world.get_room #{character.location.id}\n"

    character.inventory.each do |item|
      file << "@character.inventory << #{create_item_string item}\n"
    end

    file << "@character.location.characters << @character\n"

    if character.player
      file << "@ret.store :player, @character\n"
    end

    file
  end

  def create_item_string(item)
    "@world.create_item(\"#{item.name}\", \"#{item.short_desc}\", \"#{item.long_desc}\")"
  end
end
