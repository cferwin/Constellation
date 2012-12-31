class Container
  attr_accessor :max_size
  attr_reader :size, :objects

  def initialize(max_size = nil)
    @size = 0
    @max_size = max_size
    @objects = []
  end

  # Add an object to the container
  def add(object)
    objects << object
    @size = @size + 1
  end

  # Remove an object from the container
  def remove(object)
    objects.delete object
    @size = @size - 1
  end

  def empty?
    objects.empty?
  end

  # Use object.name to find an object
  def find_by_name(name)
    found = []

    @objects.each do |object|
      if object.name == name
        found << object
      end
    end

    if found.empty?
      nil
    else
      found
    end
  end
end
