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
    puts("#{@player.location.name}".bold + "\n\n#{@player.location.long_desc}\n\n")

    # List items
    unless @player.location.items.empty?
      puts("You see...")
      @player.location.items.each do |item|
        puts("#{item.name}".bold)
      end
      puts
    end

    # List exits
    puts  "You can exit:"
    @player.location.exits.each do |direction, room|
      print("#{direction.to_s} ".bold)
    end
    puts
  end
  add_alias "l", "look"

  # How should multiple items by one name be handled?
  keyword "take" do
    # No object name given
    if @line.empty?
      puts "Take what?"
      return
    end

    if items = @player.take_item(@player.location, @line.join(" "))
      # One item found by name, item successfully taken
      if items.size == 1
        puts "Picked up #{aoran @line.join(" ")}"
      else
        # Multiple items found by name, specify by number in a list
        puts "Which one?"
        (1..items.size).each do |i|
          puts "#{i} : #{items[i-1].name}".bold
        end

        print "Item Number: "
        begin
          id = Integer($stdin.gets)
        rescue
          puts("Invalid Number")
          return
        end

        # Item successfully taken
        if @player.take_item_object(@player.location, items[id-1])
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
    # No item name given
    if @line.empty?
      puts "Drop what?"
      return
    end

    if items = @player.drop_item(@line.join(" "))
      # One item found by name, item successfully dropped
      if items.size == 1
        puts "Dropped #{aoran @line.join(" ")}"
      else
        # Multiple items found by name, specify by number in a list
        puts "Which one?"
        (1..items.size).each do |i|
          puts "#{i} : #{items[i-1].name}".bold
        end

        print "Item Number: "
        begin
          id = Integer($stdin.gets)
        rescue
          puts("Invalid Number")
          return
        end

        # Item successfully dropped
        if @player.drop_item_object(items[id-1])
          puts "Dropped #{aoran @line.join(" ")}"
        else
          puts "Invalid number"
        end
      end
    else
      # No item found by name
      puts "I don't have #{aoran @line.join(" ")}"
    end
  end
  add_alias "d", "drop"

  keyword "inventory" do
    puts "Inventory:".bold
    if @player.inventory.empty?
      puts "You have nothing in your inventory."
    else
      @player.inventory.each do |item|
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
    @world.save(File.join(File.dirname(__FILE__), @line)) and exit
  end
end
