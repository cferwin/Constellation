require_relative './entity'

class Room < Entity
  attr_accessor :entities, :north, :east, :south, :west, :up, :down
end
