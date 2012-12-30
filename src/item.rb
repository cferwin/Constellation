require_relative './entity'

class Item < Entity
  attr_accessor :name, :short_desc, :long_desc, :parts, :durability

  def load(&block)
    instance_eval(&block)
  end
end
