require_relative './entity'

class Item < Entity
  attr_accessor :parts, :durability
end
