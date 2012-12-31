require_relative './container'

class Room
  attr_accessor :id, :name, :short_desc, :long_desc, :exits
  attr_reader :items, :characters

  def initialize(name, &block)
    @name = name
    @characters = []
    @items = Container.new
    @exits = {}

    instance_eval(&block) if block
  end

  def item(name, &block)
    item = Item.new(name, &block)

    @items.add item if item
  end

  def character(name, &block)
    character = Character.new(name, &block)

    @characters << character if character
  end

  def set_exit(direction, room)
    exits[direction] = room
  end

  def get_exit(direction)
    exits[direction]
  end
end
