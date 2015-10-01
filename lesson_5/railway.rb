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
      train.arrive_at(self)
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
      train.depart_from(self)
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
   
  def arrive_at(new_station)
    if @station
      puts "Error: before arriving at station #{new_station.name}, train ##{@num} must depart from station #{@station.name}"
    else
      @station = new_station
    end
  end

  def depart_from(old_station)
    if @station == old_station
      @station = nil
    else
      if @station
        puts "Error: train ##{@num} can't depart from #{old_station.name} because it is at #{@station.name}"
      else
        puts "Error: train ##{@num} can't depart from #{old_station.name} because it is not at a station"
      end
    end
  end


end
