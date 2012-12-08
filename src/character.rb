require_relative './entity'

class Character < Entity
  attr_accessor :inventory, :health, :location

  def move_to(room)
    if @location
      @location.characters.delete self
    end

    @location = room
    @location.characters << self
  end

  def move(direction)
    unless @location.get_exit(direction) == nil
      move_to @location.get_exit(direction)
      @location
    else
      nil
    end
  end
end
