require_relative './processor'
require_relative './room'
require_relative './character'
require_relative './item'
if ENV["os"] == "Windows_NT"
  require 'win32console'
end
require 'smart_colored/extend'

class World
  attr_accessor :rooms, :characters, :items, :player

  def initialize(path = nil)
    @path = path
    @rooms = {}
    @characters = {}
    @items = {}
    @saved = []
    @player = Character.new(0, "", "", "")

    if path
      instance_eval(File.read(File.join(File.dirname(__FILE__), path)))
    end

    # Find the player
    @rooms.each do |id, room|
      room.characters.each do |char|
        if char.player
          char.location = @player.location
          @player = char
        end
      end
    end

    # Try to get room objects for exits if they're IDs
    @rooms.each do |id, room|
      room.exits.each do |dir, obj|
        if get_room obj
          room.set_exit(dir, get_room(obj))
        end
      end
    end
  end

  # Rooms
  def room(name, &block)
    id = 0
    # Try to find a free ID for the room
    while get_room(id) != nil
      id += 1
    end

    room = Room.new(id, name, "", "")
    room.load(&block)

    add_room(room)
    room
  end

  def get_room(id)
    if rooms.has_key?(id)
      rooms[id]
    else
      nil
    end
  end

  def add_room(room)
    @rooms.store room.id, room

    return room.id
  end

  def remove_room(id)
    rooms.delete id
  end

  def create_room(id = 0, name, short_desc, long_desc)
    while get_room(id) != nil
      # Try to find a free ID for the room
      id += 1
    end

    get_room(add_room(Room.new(id, name, short_desc, long_desc)))
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
    @characters.store character.id, character

    return character.id
  end

  def remove_character(id)
    characters.delete id
  end

  def create_character(id = 0, name, short_desc, long_desc)
    while get_character(id) != nil
      # Try to find a free ID
      id += 1
    end

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
    @items.store item.id, item

    return item.id
  end

  def remove_item(id)
    @items.delete id
  end

  def create_item(id = 0, name, short_desc, long_desc)
    while get_item(id) != nil
      # Try to find a free ID
      id += 1
    end

    get_item(add_item(Item.new(0, name, short_desc, long_desc)))
  end

  def save(path = nil)
    if path
      file = File.open(path, "w")
    else
      if @path
        file = File.open(@path, "w")
      else
        puts "ERROR: Could not find the world save file. Please retry with a file path".bold.red
        return
      end
    end

    @rooms.each do |id, room|
      unless @saved.include?(room.id)
        file.write save_room(room)
        @saved << room.id
      end
    end

    file.write "@player.location = get_room(#{@player.location.id})"
  end

  private
  def save_room(room)
    string = String.new
    # Create the room or get the object
    unless @saved.include? room.id
      string << "room \"#{room.name}\" do\n"
        string << "\t@id = #{room.id}\n"
        string << "\t@short_desc = \"#{room.short_desc}\"\n"
        string << "\t@long_desc = \"#{room.long_desc}\"\n"
      @saved << room.id

      # Save room items
      unless room.items.empty?
        string << "\n# Room #{room.id} Items\n"
        room.items.each do |item|
          string << "#{save_item(item)}"
        end
      end

      # Save room characters
      unless room.characters.empty?
        string << "\n\t# Room #{room.id} Characters\n"
        room.characters.each do |character|
          string << "#{save_character(character)}\n"
        end
      end

      room.exits.each do |dir, obj|
        string << "\tset_exit :#{dir}, #{obj.id}\n"
      end

      string << "end\n\n"
    end
    string
  end

  def save_character(character)
    string = String.new

    string << "\tcharacter \"#{character.name}\" do\n"
      if character.player
        string << "\t\tplayer = true\n"
      end
      string << "\t\t@id = #{character.id}\n"
      string << "\t\t@short_desc = \"#{character.short_desc}\"\n"
      string << "\t\t@long_desc = \"#{character.long_desc}\"\n"

    # Save inventory items
    unless character.inventory.empty?
      string << "\n\t# Inventory Items\n"
      character.inventory.each do |item|
        string << "#{save_item(item)}"
      end
    end

    string << "\tend\n"

    string
  end

  def save_item(item)
    string = String.new

    string << "\titem \"#{item.name}\" do\n"
      string << "\t\t@id = #{item.id}\n"
      string << "\t\t@short_desc = \"#{item.short_desc}\"\n"
      string << "\t\t@long_desc = \"#{item.long_desc}\"\n"
    string << "\tend\n\n"
    
    string
  end
end
