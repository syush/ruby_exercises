class Station
  def initialize (name)
    @name = name
    @train_list = []
  end
 
  attr_reader :name
  
  def accept_train (train)
    if @train_list.include?(train)
      puts "Error: station #{@name} trying to accept train ##{train.num} which is already there"
    else
      @train_list << train
    end
  end

  def print_trains
    if @train_list.empty?
      puts "There are no trains at station #{@name}."
    else
      puts "The following trains are currently at station #{@name}:"
      @train_list.each {|train| puts "Train ##{train.num} (#{train.type})"}
    end
  end

  def print_trains_per_type
    trains_per_type = {passenger:[], freight:[]}
    @train_list.each {|train| trains_per_type[train.type] << train}
    [:passenger, :freight].each do |type|
      n = trains_per_type[type].size
      if n == 0
        puts "There are no #{type} trains at station #{@name}."
      else
        puts "There #{n==1 ? "is" : "are"} #{n} #{type} train#{n==1 ? "" : "s"} at station #{@name}:"
        trains_per_type[type].each {|train| puts "Train ##{train.num}"}
      end
    end
  end

  def release_train (train)
    if @train_list.include?(train)
      @train_list.delete(train)
    else
      puts "Error: station #{@name} trying to release train ##{train.num} which is not there"
    end
  end     
end

class Train
  def initialize (num, type, num_cars)
    if ([ :freight, :passenger]).include?(type)
      @type = type
    else
      puts "Error: unknown train type"
      @type = :passenger
    end
    if num_cars >= 0
      @num_cars = num_cars
    else
      puts "Error: negative number of cars" 
      @num_cars = 0
    end
    @num = num
    @speed = 0
    @station = nil
    @at_station = false
    @route = nil
  end

  attr_reader :num
  attr_reader :type

  def speed_up
    if @speed > 100
      puts "Error: train ##{@num} can't speed up since it's moving at max speed" if @speed == 110
    else
      @speed += 10 
    end  
  end
   
  def print_speed
    if @speed > 0
      puts "Train ##{@num} is moving at speed #{@speed} km/h"
    else
      puts "Train ##{@num} is not moving"
    end
  end

  def slow_down
    if @speed < 10
      puts "Error: train ##{@num} can't slow down since it is not moving" if @speed == 0
    else
      @speed -= 10
    end
  end

  def add_car
    if @speed == 0
      @num_cars += 1
    else
      puts "Error: can't add a car to train ##{@num} since it is moving"
    end
  end

  def remove_car
    if @speed == 0
      if @num_cars > 0
        @num_cars -= 1
      else
        puts "Error: can't remove a car; train ##{@num} is just a bare locomotive"
      end
    else
      puts "Error: can't remove a car from train ##{@num} since it is moving"
    end
  end

  def print_num_cars
    puts "Train ##{@num} has #{@num_cars} cars."
  end
   
  def arrive
    if @at_station
      puts "Error: train ##{@num} is already at station #{@station.name}"
    else
      @station.accept_train(self)
      @at_station = true
    end
  end

  def depart_forward
    if @at_station
      if @route && @route.last?(@station)
        puts "Error: train ##{@num} is at the final destination; can't move forward."
      elsif @route
        @station.release_train(self)
        @at_station = false
        @station = @route.next(@station)
      end
    else
      puts "Error: train ##{@num} can't depart because it is not at a station."
    end
  end
  
  def depart_backward
    if @at_station
      if @route && @route.first?(@station)
        puts "Error: train ##{@num} is at the starting point; can't move backward."
      elsif @route
        @station.release_train(self)
        @at_station = false
        @station = @route.prev(@station)
      end
    else
      puts "Error: train ##{@num} can't depart because it is not at a station."
    end
  end

  def assign_route(route)
    if @station && @at_station
      if route.include?(@station)
        @route = route
      else
        puts "Error: before assigning the route, train ##{@num} must leave #{@station.name} which is not on the route."
      end
    else
      @route = route
      @station = @route.first
      @at_station = false
    end
  end

  def print_current_station
    if @station 
      puts "Train ##{@num} is currently at #{@station.name}."
    else
      puts "Train ##{@num} is not at a station currently."
    end
  end

  def print_prev_station
    if @cur_index > 0
      puts "The previous station for train ##{@num} was #{@route[@cur_index-1].name}."
    else
      puts "Train ##{@num} is at the initial station."
    end
  end

  def print_next_station
    next_index = @station ? @cur_index : @cur_index + 1
    if next_index < @route.length
      puts "The next station for train ##{@num} is #{@route.get_station(next_index).name}."
    else
      puts "Train ##{@num} is at the final destination."
    end
  end


end

class Route
  def initialize(first, last)
    @list = [first, last]
    @cur_index = 0
  end

  def add_station(new_station, prev_station)
    if @list.include?(prev_station)
      @list.insert(@list.index(prev_station) + 1, new_station)
    else
      puts "Error: can't insert #{new_station.name} since the route doesn't contain #{prev_station.name}"
    end
  end
  
  def remove_station(station)
    if @list.include?(station)
      @list.delete(station)
    else
      puts "Error: can't remove #{station.name} from the route since it's not there"
    end
  end

  def first
    @list.first
  end
  
  def last
    @list.last
  end

  def first?(station)
    @list.first == station
  end

  def last?(station)
    @list.last == station
  end

  def next(station)
    @list[@list.index(station) + 1]
  end

  def prev(station)
    @list[@list.index(station) - 1]
  end

  def include?(station)
    @list.include?(station)
  end

  def print
    puts "The route consists of the following stations:"
    @list.each {|station| puts station.name}
  end
end
