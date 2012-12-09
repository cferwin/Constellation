require 'rspec'
require_relative '../src/world'
require_relative '../src/character'

describe Character do
  before :all do
    @world = World.new
    @character = @world.create_character("Test Char", "", "")
    @room = @world.create_room("Test Room", "", "")
  end

  it 'can move to a room' do
    @character.move_to @room
    @character.location.id.should eq @room.id
    @room.characters.include?(@character).should be_true
  end

  it 'can move in a direction' do
    @north = @world.create_room("North", "", "")
    @room.north = @north

    @character.location.should eq @room
    @character.move :north
    @character.location.should eq @north

    @room.characters.include?(@character).should_not be_true
    @north.characters.include?(@character).should be_true
    @character.move_to @room
  end

  it 'can take items from a container' do
    @room.items << @world.create_item("Test Item", "", "")
    @room.items.last.name.should eq "Test Item"

    @item = @character.take_item @room, "Test Item"
    @item.should_not be_nil
    @character.inventory.include?(@item.first).should be_true
  end
end
