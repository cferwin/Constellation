class Entity
  attr_accessor :name, :short_desc, :long_desc

  def initialize(name, short_desc, long_desc)
    @name = name
    @short_desc = short_desc
    @long_desc = long_desc
  end
end
