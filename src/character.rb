require_relative './entity'

class Character < Entity
  attr_accessor :inventory, :health, :location
end
