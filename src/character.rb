class Character
  attr_accessor :id, :name, :short_desc, :long_desc, :inventory, :health, :location, :player

  def initialize(name, &block)
    @name = name
    @inventory = []
    @health = 100
    @player = false
    instance_eval(&block) if block
  end

  def item(name, &block)
    item = Item.new(name, &block)

    @inventory << item if item
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

  def take_item(container, name)
    @ret = container.get_items_by_name(name)

    if @ret.nil?
      return nil
    end

    if @ret.size == 1
      item = @ret.first

      container.remove_item item
      @inventory << item
      return @ret
    else
      @ret
    end
  end

  def take_item_object(container, object)
    container.remove_item object
    @inventory << object
  end

  def move_item_to(container, name)
    @ret = get_items_by_name(name)

    if @ret.nil?
      return nil
    end

    if @ret.size == 1
      item = @ret.first

      move_item_to_object container, item
      return @ret
    else
      @ret
    end
  end

  def move_item_to_object(container, object)
    @inventory.delete object
    container.add_item object
  end

  def drop_item(name)
    move_item_to(@location, name)
  end

  def drop_item_object(object)
    move_item_to_object @location, object
  end
end

def get_items_by_name(name)
  @ret = []

  @inventory.each do |item|
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
