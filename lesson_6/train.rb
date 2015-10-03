require_relative 'station'
require_relative 'route'

class Train

  def initialize (num, num_cars, type=:passenger)
    init_num(num)
    init_type(type)
    init_num_cars(num_cars)
    init_defaults
  end

  attr_reader :num
  attr_reader :type
  attr_reader :num_cars

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

  def add_car(car)
    if @speed > 0
      puts "Error: can't add a car to train ##{@num} since it is moving"
    elsif car.type != @type
      puts "Error: can't attach a #{car.type} car to a #{@type} train"
    else
      @num_cars += 1
      @cars << car
      car.attach(self, @num_cars)
    end
  end

  def remove_car
    if @speed == 0
      if @num_cars > 0
        @cars.last.detach
        @cars.pop
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
        @forward = true
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
        @forward = false
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
    if @at_station 
      puts "Train ##{@num} is currently at #{@station.name}."
    else
      puts "Train ##{@num} is not at a station currently."
    end
  end

  def print_prev_station
    if @route.first?(@station) && (@at_station || @forward)         
      puts "Train ##{@num} is at the initial station."
    else
      prev =  @at_station || @forward ? @route.prev(@station) : @station
      puts "The previous station on the route for train ##{@num} is #{prev.name}."
    end
  end

  def print_next_station
    if @route.last?(@station) && (@at_station || !@forward)         
      puts "Train ##{@num} is at the final destination."
    else
      nxt =  !@at_station && @forward ? @station : @route.next(@station) 
      puts "The next station on the route for train ##{@num} is #{nxt.name}."
    end
  end
 
protected

  def init_num(num)
    @num = num
  end

  def init_type(type)
    if ([ :cargo, :passenger]).include?(type)
      @type = type
    else
      puts "Error: unknown train type"
      @type = :passenger
    end
  end

  def init_num_cars(num_cars)
    if num_cars >= 0
      @num_cars = num_cars
    else
      puts "Error: negative number of cars" 
      @num_cars = 0
    end
  end 

  def init_defaults
    @speed = 0
    @station = nil
    @forward = true
    @at_station = false
    @route = nil
    @cars = []
  end

end

