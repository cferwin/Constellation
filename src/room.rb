require_relative './entity'

class Room < Entity
  attr_accessor :characters, :items, :north, :east, :south, :west, :up, :down

  def initialize(id, name, short_desc, long_desc)
    @id = id
    @name = name
    @short_desc = short_desc
    @long_desc = long_desc
    @characters = []
    @items = []
  end

  def get_exit(direction)
    case
    when direction == :north
      north
    when direction == :east
      east
    when direction == :south
      south
    when direction == :west
      west
    when direction == :north
      north
    when direction == :up
      up
    when direction == :down
      down
    end
  end
end
