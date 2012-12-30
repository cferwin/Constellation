room "Road" do
	@id = 0
	@short_desc = "You're standing at the end of a road..."
	@long_desc = "You're standing at the end of a road..."

# Room 0 Items
	item "Bread" do
		@id = 0
		@short_desc = "A piece of bread."
		@long_desc = "A regular sized slice of bread. It looks pretty fresh."
	end

	item "Water" do
		@id = 0
		@short_desc = "A bottle of water."
		@long_desc = "A liter of water in a stainless steel bottle."
	end


	# Room 0 Characters
	character "Test Player" do
		@id = 0
		@short_desc = "The player's description"
		@long_desc = "The player's long description"

	# Inventory Items
	item "Journal" do
		@id = 0
		@short_desc = "The player's journal."
		@long_desc = "The player's journal."
	end

	item "Pen" do
		@id = 0
		@short_desc = "A pen."
		@long_desc = "A nice pen."
	end

	end

	character "" do
		@id = 0
		@short_desc = ""
		@long_desc = ""
	end

	set_exit :north, 1
end

room "North Hall" do
	@id = 1
	@short_desc = "You're standing at the end of a road..."
	@long_desc = "You're standing at the end of a road..."

	# Room 1 Characters
	character "" do
		@id = 0
		@short_desc = ""
		@long_desc = ""
	end

	set_exit :south, 0
end

@player.location = get_room(0)