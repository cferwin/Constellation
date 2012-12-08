class Entity
  attr_accessor :id, :name, :short_desc, :long_desc

  def initialize(id, name, short_desc, long_desc)
    @id = id
    @name = name
    @short_desc = short_desc
    @long_desc = long_desc
  end
end
