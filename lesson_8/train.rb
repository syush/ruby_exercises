require_relative 'station'
require_relative 'route'
require_relative 'producer'
require_relative 'instance_counter'
require_relative 'exceptions'

class Train

  include InstanceCounter

  def initialize (num, type)
    @num = num
    @type = type
    validate!
    init_defaults
    @@all_trains[num] = self
    register_instance
  end

  def valid?
    self.class.correct_num_format?(@num) && correct_type?(@type)
  end

  @@all_trains = {}

  def self.all_trains
    @@all_trains
  end
 
  def self.get_by_number(num)
    train = @@all_trains[num]
  end

  def self.none?
    @@all_trains == {}
  end
 
  def self.correct_num_format?(num)
    num =~/\A[a-zа-я0-9]{3}-?[a-zа-я0-9]{2}\z/i
  end


  include Producer

  attr_reader :num
  attr_reader :type
  attr_reader :at_station
  attr_reader :cars

  def speed_up
    raise ProhibitionError, "Train ##{@num} can't speed up since it's moving at max speed"  if @speed > 100 
    @speed += 10 
  end
   
  def print_speed
    if @speed > 0
      puts "Train ##{@num} is moving at speed #{@speed} km/h" 
    else
      puts "Train ##{@num} is not moving"
    end
  end

  def slow_down
    raise ProhibitionError, "Train ##{@num} can't slow down since it is not moving" if @speed == 0
    @speed -= 10
  end

  def add_car(car)
    raise ProhibitionError, "Can't add a car to train ##{@num} since it is moving"  if @speed > 0
    raise ProtectionError, "Can't attach a #{car.type} car to #{@type} train ##{@num}" if car.type != @type
    raise ProtectionError, "Invalid car trying to be attached to train ##{@num}" if !car.valid?
    @cars << car
    car.attach(self, @cars.size)
  end

  def remove_car
    raise ProhibitionError, "Can't remove a car; train ##{@num} is just a bare locomotive" if @cars.empty? 
    raise ProhibitionError, "Can't remove a car from train ##{@num} since it is moving"  if @speed > 0
    @cars.last.detach
    @cars.pop
  end

  def print_num_cars
    puts "Train ##{@num} has #{@cars.size} cars."
  end
  
  def num_cars
    @cars.size
  end
 
  def arrive
    raise ProhibitionError, "No route has been assigned to train ##{@num}" if !@route
    raise ProhibitionError, "Train ##{@num} is already at station #{@station.name}"  if @at_station
    @station.accept_train(self)
    @at_station = true
  end

  def depart_forward
    raise ProhibitionError, "No route has been assigned to train ##{@num}" if !@route
    raise ProhibitionError, "Train ##{@num} can't depart because it is not at a station." if !@at_station || !@station
    raise ProhibitionError, "Train ##{@num} is at the final destination; can't move forward." if @route.last?(@station)
    @station.release_train(self)
    @at_station = false
    @forward = true
    @station = @route.next(@station)
  end
  
  def depart_backward
    raise ProhibitionError, "No route has been assigned to train ##{@num}" if !@route
    raise ProhibitionError, "Train ##{@num} can't depart because it is not at a station." if !@at_station || !@station
    raise ProhibitionError, "Train ##{@num} is at the starting point; can't move backward." if @route.first?(@station)
    @station.release_train(self)
    @at_station = false
    @forward = false
    @station = @route.prev(@station)
  end

  def move_directly(station)
    raise ProtectionError, "Train ##{@num} is directed to invalid station #{station.name}" if !station.valid?
    @station.release_train(self) if @at_station
    @at_station = true
    @station = station
    station.accept_train(self)
  end

  def assign_route(route)
    raise ProtectionError, "Invalid route is assigned to train ##{@num}" if !route.valid?
    if @station && @at_station && !route.include?(@station)
      raise ProhibitionError, "Before assigning the route, train ##{@num} must leave #{@station.name} which is not on the route."
    end
    @route = route
    @station = @route.first if !@at_station
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

  def init_defaults
    @speed = 0
    @station = nil
    @forward = true
    @at_station = false
    @route = nil
    @cars = []
  end

  def correct_type?(type)
    [:cargo,:passenger].include?(@type)
  end

  def validate!
    raise ProtectionError, "Wrong train format" if !self.class.correct_num_format?(@num)
    raise ProtectionError, "Unknown train type" if !correct_type?(@type)
  end  

end

