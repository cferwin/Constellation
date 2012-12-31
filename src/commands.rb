require './processor'

# Define commands
Processor.new do
  # Helpful functions
  def aoran(line)
    if "aeiou".include?(line[0])
      "an #{line}!"
    else
      "a #{line}!"
    end
  end

  keyword "look" do
    puts @player.location.name.bold
    puts
    puts @player.location.long_desc
    puts

    # List items
    unless @player.location.items.empty?
      puts "You see..." 
      @player.location.items.objects.each do |item|
        puts item.name.bold
      end
      puts
    end

    # List exits
    puts  "You can exit:"
    @player.location.exits.each do |direction, room|
      print direction.to_s.bold + " "
    end
    puts
  end
  add_alias "l", "look"

  keyword "take" do
    # No object name given
    if @line.empty?
      puts "Take what?"
      return
    end

    if items = @player.take_item_by_name(@player.location.items, @line.join)
      if items.size == 1
        # One item found by name, item successfully taken
        puts "Picked up #{aoran @line.join}"
      else
        # Multiple items found by name, specify by number in a list
        puts "Which one?"
        (1..items.size).each do |i|
          puts "#{i} : #{items[i-1].name}".bold
        end

        # Read an item number
        print "Item Number: "
        begin
          id = Integer($stdin.gets)
        rescue
          puts("Invalid Number")
          return
        end

        # Item successfully taken
        if @player.take_item(@player.location.items, items[id-1])
          puts "Picked up #{aoran @line.join(" ")}"
        else
          puts "Invalid number"
        end
      end
    else
      # No item found by name
      puts "I don't see #{aoran @line.join(" ")}"
    end
  end
  add_alias "t", "take"
  add_alias "get", "take"
  add_alias "g", "take"

  keyword "drop" do
    # No object name given
    if @line.empty?
      puts "Drop what?"
      return
    end

    if items = @player.drop_item_by_name(@line.join)
      if items.size == 1
        # One item found by name, item successfully dropped
        puts "Dropped #{aoran @line.join}"
      else
        # Multiple items found by name, specify by number in a list
        puts "Which one?"
        (1..items.size).each do |i|
          puts "#{i} : #{items[i-1].name}".bold
        end

        # Read an item number
        print "Item Number: "
        begin
          id = Integer($stdin.gets)
        rescue
          puts("Invalid Number")
          return
        end

        # Item successfully dropped
        if @player.move_item(@player.location.items, items[id-1])
          puts "Dropped #{aoran @line.join(" ")}"
        else
          puts "Invalid number"
        end
      end
    else
      # No item found by name
      puts "I don't see #{aoran @line.join(" ")}"
    end
  end
  add_alias "d", "drop"

  keyword "inventory" do
    puts "Inventory:".bold
    if @player.inventory.empty?
      puts "You have nothing in your inventory."
    else
      @player.inventory.objects.each do |item|
        puts item.name
      end
    end
  end
  add_alias "i", "inventory"

  keyword "exit" do
    exit
  end
  add_alias "quit", "exit"
  add_alias "q", "exit"

  keyword "save" do
    unless @line.empty?
      @world.save(File.join(File.dirname(__FILE__), @line)) and exit
    else
      puts "Are you sure? This will overwrite your current save file".bold.red
      print "yes/no> ".red.bold
      confirm = $stdin.gets.chomp

      if confirm.include? "y"
        @world.save and exit
      end
    end
  end
end
