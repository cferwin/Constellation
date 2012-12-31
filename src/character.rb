require_relative './container'

class Character
  attr_accessor :id, :name, :short_desc, :long_desc, :health, :location, :player
  attr_reader :inventory

  def initialize(name, &block)
    @name = name
    @inventory = Container.new
    @health = 100
    @player = false

    instance_eval(&block) if block
  end

  def item(name, &block)
    item = Item.new(name, &block)

    @inventory.add item if item
  end

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

  def take_item_by_name(container, name)
    items = container.find_by_name(name)

    if items
      if items.size == 1
        item = items.first

        container.remove item
        @inventory.add item
      end
    end

    items
  end

  def take_item(container, object)
    container.remove object
    @inventory.add object
  end

  def move_item_by_name(container, name)
    items = @inventory.find_by_name(name)

    if items
      if items.size == 1
        item = items.first

        @inventory.remove item
        container.add item
      end
    end
    
    items
  end

  def move_item(container, object)
    @inventory.remove object
    container.add object
  end

  def drop_item_by_name(name)
    move_item_by_name(@location.items, name)
  end

  def drop_item(object)
    move_item(@location.items, object)
  end
end
