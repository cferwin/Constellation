require 'rspec'
require_relative '../src/world'
require_relative '../src/character'

describe Character do
  before :all do
    @world = World.new
    @character = @world.create_character("Test Char")
    @room = @world.create_room("Test Room")
  end

  it 'can move to a room' do
    @character.move_to @room
    @character.location.id.should eq @room.id
    @room.characters.include?(@character).should be_true
  end

  it 'can move in a direction' do
    @north = @world.create_room("North")
    @room.set_exit :north, @north

    @character.location.should eq @room
    @character.move :north
    @character.location.should eq @north

    @room.characters.include?(@character).should_not be_true
    @north.characters.include?(@character).should be_true
    @character.move_to @room
  end

  it 'can take items' do
    @room.items.add @world.create_item("Test Item")
    @room.items.objects.last.name.should eq "Test Item"

    @item = @character.take_item_by_name @room.items, "Test Item"
    @item.should_not be_nil
    @character.inventory.objects.include?(@item.first).should be_true
  end

  it 'can drop items' do
    @character.inventory.empty?.should_not be_true
    @room.items.objects.empty?.should be_true

    @character.move_item_by_name @room.items, "Test Item"

    @character.inventory.empty?.should be_true
    @room.items.objects.empty?.should_not be_true
  end
end
