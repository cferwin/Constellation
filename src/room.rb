require_relative './entity'

class Room < Entity
  attr_accessor :characters, :items, :exits

  def initialize(id, name, short_desc, long_desc)
    @id = id
    @name = name
    @short_desc = short_desc
    @long_desc = long_desc
    @characters = []
    @items = []
    @exits = {}
  end

  def load(&block)
    instance_eval(&block)
  end

  def item(name, &block)
    item = Item.new(0, name, "", "")
    item.load(&block)

    @items << item if item
  end

  def character(name, &block)
    character = Character.new(0, name, "", "")
    character.load(&block)

    @characters << character if character
  end

  def set_exit(direction, room)
    exits[direction] = room
  end

  def connect_room(direction, room, opposite_direction)
    exits[direction] = room
    room.exits[opposite_direction] = self
  end

  def get_exit(direction)
    exits[direction]
  end

  def get_items_by_name(name)
    @ret = []

    @items.each do |item|
      if item.name == name
        @ret << item
      end
    end

    if @ret.empty?
      nil
    else
      @ret
    end
  end

  def add_item(item)
    items << item
  end

  def remove_item(item)
    items.delete item
  end
end
