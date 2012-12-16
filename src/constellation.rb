require_relative './processor.rb'
require_relative './world.rb'
require 'smart_colored/extend'

# Define world
@file = eval(File.read("/home/chris/prog/constellation/data/s.rb"))
@world = @file[:world]
@player = @file[:player]
@player.player = true

# Define commands
@cmd = Processor.new

def expand_direction(direction)
  case direction
    when :n
      direction = :north
    when :s
      direction = :south
    when :e
      direction = :east
    when :w
      direction = :west
    when :u
      direction = :up
    when :d
      direction = :down
  end

  direction
end

# To display "can't go..." message when the player is using a standard direction
def is_direction(direction)
  if [:north, :south, :east, :west, :up, :down].include?(expand_direction(direction))
    direction
  else
    nil
  end
end

def move(direction)
  if @player.move(expand_direction(direction))
    @cmd.process("look")
    @player.location
  else
    puts "You can't go that way!"
    nil
  end
end

def aoran(t)
  if "aeiou".include?(t[0])
    "an #{t}!"
  else
    "a #{t}!"
  end
end

@cmd.add_command :create, lambda { |t|
    if t[0] == "room"
      print "Name: "
      name = gets.chomp

      print "Short Description: "
      short_desc = gets.chomp

      print "Long Description: "
      long_desc = gets.chomp

      nr = @world.create_room(name, short_desc, long_desc)
      @player.location.connect_room(t[1].to_sym, nr, t[2].to_sym)
      return
    end

    if t[0] == "library"
      nr = @world.create_room("Library", "This room has many bookshelves in it.", "There are many bookshelves in this room. The rows must be thirty feet long. There seems to be a space between one of the shelves and the floor.")
      @player.location.connect_room(t[1].to_sym, nr, t[2].to_sym)
      return
    end

    if t[0] == "crawlspace"
      nr = @world.create_room("Crawlspace", "A small space below the shelves.", "The air in this tiny space is dusty, but it smells of leather and old paper.")
      @player.location.connect_room(t[1].to_sym, nr, t[2].to_sym)
      return
    end

    puts "I don't know how to create #{aoran t.join(" ")}!"
  }

@cmd.add_command :look, lambda { |t|
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
  }
@cmd.add_alias :l, :look

@cmd.add_command :take, lambda { |t|
    # No object name given
    if t.empty?
      puts "Take what?"
      return
    end

    if items = @player.take_item(@player.location, t.join(" "))
      # One item found by name, item successfully taken
      if items.size == 1
        puts "Picked up #{aoran t.join(" ")}"
      else
        # Multiple items found by name, specify by number in a list
        puts "Which one?"
        (1..items.size).each do |i|
          puts "#{i} : #{items[i-1].name}".bold
        end

        print "Item Number: "
        begin
          id = Integer(gets)
        rescue
          puts("Invalid Number")
          return
        end

        # Item successfully taken
        if @player.take_item_object(@player.location, items[id-1])
          puts "Picked up #{aoran t.join(" ")}"
        else
          puts "Invalid number"
        end
      end
    else
      # No item found by name
      puts "I don't see #{aoran t.join(" ")}"
    end
  }
@cmd.add_alias :t, :take
@cmd.add_alias :get, :take
@cmd.add_alias :g, :take
@cmd.add_alias :pick, :take

@cmd.add_command :inventory, lambda { |t|
    puts "Inventory:".bold
    if @player.inventory.empty?
      puts "You have nothing in your inventory."
    else
      @player.inventory.each do |item|
        puts item.name
      end
    end
  }
@cmd.add_alias :i, :inventory
@cmd.add_alias :inv, :inventory

@cmd.add_command :drop, lambda { |t|
    # No item name given
    if t.empty?
      puts "Drop what?"
      return
    end

    if items = @player.drop_item(t.join(" "))
      # One item found by name, item successfully dropped
      if items.size == 1
        puts "Dropped #{aoran t.join(" ")}"
      else
        # Multiple items found by name, specify by number in a list
        puts "Which one?"
        (1..items.size).each do |i|
          puts "#{i} : #{items[i-1].name}".bold
        end

        print "Item Number: "
        begin
          id = Integer(gets)
        rescue
          puts("Invalid Number")
          return
        end

        # Item successfully dropped
        if @player.drop_item_object(items[id-1])
          puts "Dropped #{aoran t.join(" ")}"
        else
          puts "Invalid number"
        end
      end
    else
      # No item found by name
      puts "I don't have #{aoran t.join(" ")}"
    end
  }
@cmd.add_alias :d, :drop

@cmd.add_command :quit, lambda { |t| exit }

@cmd.add_command :save, lambda { |t| @world.save(File.join(File.dirname(__FILE__), "../data/s.rb")) and exit }
@cmd.add_alias :sq, :save
@cmd.add_alias :q, :sq

while true do
  print "> "
  @line = gets.chomp

  begin
    @cmd.process @line
  rescue RuntimeError
    if @player.location.get_exit(expand_direction(@line.to_sym)) || is_direction(expand_direction(@line.to_sym))
      move @line.to_sym
    else
      puts "Command Unknown"
    end
  end
end
