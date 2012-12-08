require 'rspec'
require_relative '../src/world'

describe World do
  before :all do
    @world = World.new
  end

  it 'can add rooms' do
    @room = @world.add_room("Test Room")
    @room.should eq 0
  end

  it 'can create rooms' do
    @room = @world.create_room("Test Room", "A test room", "")
    @room.should eq 1
  end

  it 'can get rooms' do
    @world.get_room(0).should eq "Test Room"
    @world.get_room(1).name.should eq "Test Room"
  end

  it 'can remove rooms' do
    @world.remove_room(0)
    @world.get_room(0).should be_nil
  end
end
