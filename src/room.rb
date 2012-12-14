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

  def set_exit(direction, room)
    exits[direction] = room
  end

  def connect_room(direction, room, opposite_direction)
    exits[direction] = room
    room.set_exit[opposite_direction] = self
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
