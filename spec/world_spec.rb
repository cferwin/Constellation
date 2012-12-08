require 'rspec'
require_relative '../src/world'

describe World do
  before :all do
    @world = World.new
  end

  describe "Rooms" do
    it 'can add rooms' do
      @room = Room.new(5, "Test Room", "", "")
      @created_room = @world.add_room(@room)
      @room.id.should eq 0
      @created_room.should eq @room.id
    end

    it 'can create rooms' do
      @room = @world.create_room("Test Room", "A test room", "")
      @room.id.should eq 1
    end

    it 'can get rooms' do
      @world.get_room(0).name.should eq "Test Room"
      @world.get_room(1).name.should eq "Test Room"
    end

    it 'can remove rooms' do
      @world.remove_room(0)
      @world.get_room(0).should be_nil
    end
  end

  describe "Characters" do
    it 'can create characters' do
      @character = @world.create_character("Test Char", "", "")
      @character.name.should eq "Test Char"
    end

    it 'can get characters' do
      @character = @world.create_character("Test Char", "", "")
      @world.get_character(@character.id).name.should eq "Test Char"
    end

    it 'can delete characters' do
      @character = @world.create_character("Test Char", "", "")
      @id = @character.id
      @world.remove_character(@character.id)
      @world.get_character(@id).should eq nil
    end
  end
end
