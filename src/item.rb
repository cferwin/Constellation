class Item
  attr_accessor :id, :name, :short_desc, :long_desc

  def initialize(name, &block)
    @name = name
    @short_desc = short_desc
    @long_desc = long_desc
    instance_eval(&block) if block
  end
end
