require_relative './processor'
require_relative './room'

class World
  attr_accessor :rooms

  def initialize
    @rooms = {}
    @max_room_id = 0
  end

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
    add_room(Room.new(0, name, short_desc, long_desc))
  end
end
