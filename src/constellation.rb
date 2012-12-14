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

def move(direction)
  if @player.move direction
    @cmd.process("look")
  else
    puts "You can't go that way!"
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
      name = gets

      print "Short Description: "
      short_desc = gets

      print "Long Description: "
      long_desc = gets

      nr = @world.create_room(name, short_desc, long_desc)
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
    [:north, :south, :east, :west, :up, :down].each do |direction|
      if @player.location.get_exit direction
        print("#{direction} ".bold)
      end
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
      puts "Take what?"
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

@cmd.add_command :north, lambda { |t|
    move :north
  }
@cmd.add_alias :n, :north

@cmd.add_command :south, lambda { |t|
    move :south
  }
@cmd.add_alias :s, :south

@cmd.add_command :west, lambda { |t|
    move :west
  }
@cmd.add_alias :w, :west

@cmd.add_command :east, lambda { |t|
    move :east
  }
@cmd.add_alias :e, :east

@cmd.add_command :up, lambda { |t|
    move :up
  }
@cmd.add_alias :u, :up

@cmd.add_command :down, lambda { |t|
    move :down
  }
@cmd.add_alias :d, :down

@cmd.add_command :quit, lambda { |t| @world.save(File.join(File.dirname(__FILE__), "../data/s.rb")) and exit }
@cmd.add_alias :q, :quit

while true do
  print "> "
  @line = gets.chomp

  begin
    @cmd.process @line
  rescue RuntimeError
    puts "Command Unknown"
  end
end
