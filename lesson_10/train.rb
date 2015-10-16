require_relative 'station'
require_relative 'route'
require_relative 'producer'
require_relative 'instance_counter'
require_relative 'exceptions'

class Train

  include InstanceCounter
  include Producer

  attr_reader :num
  attr_reader :type
  attr_reader :at_station
  attr_reader :cars

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
    num =~ /\A[a-zа-я0-9]{3}-?[a-zа-я0-9]{2}\z/i
  end

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

  def each_car
    @cars.each { |car| yield(car) }
  end

  def speed_up
    if @speed > 100
      fail ProhibitionError, "Train ##{@num} can't speed up since it's moving at max speed"
    end
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
    fail ProhibitionError, "Train ##{@num} can't slow down since it is not moving" if @speed == 0
    @speed -= 10
  end

  def stop
    @speed = 0
  end

  def add_car(car)
    fail ProhibitionError, "Can't add a car to train ##{@num} since it is moving"  if @speed > 0
    unless car.type == @type
      fail ProtectionError, "Can't attach a #{car.type} car to #{@type} train ##{@num}"
    end
    fail ProtectionError, "Invalid car trying to be attached to train ##{@num}" unless car.valid?
    @cars << car
    car.attach(self, @cars.size)
  end

  def remove_car
    if @cars.empty?
      fail ProhibitionError, "Can't remove a car; train ##{@num} is just a bare locomotive"
    end
    if @speed > 0
      fail ProhibitionError, "Can't remove a car from train ##{@num} since it is moving"
    end
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
    fail ProhibitionError, "No route has been assigned to train ##{@num}" unless @route
    fail ProhibitionError, "Train ##{@num} is already at station #{@station.name}" if @at_station
    @station.accept_train(self)
    @at_station = true
  end

  def depart_forward
    fail ProhibitionError, "No route has been assigned to train ##{@num}" unless @route
    if !@at_station || !@station
      fail ProhibitionError, "Train ##{@num} can't depart because it is not at a station."
    end
    if @route.last?(@station)
      fail ProhibitionError, "Train ##{@num} is at the final destination; can't move forward."
    end
    @station.release_train(self)
    @at_station = false
    @forward = true
    @station = @route.next(@station)
  end

  def depart_backward
    fail ProhibitionError, "No route has been assigned to train ##{@num}" unless @route
    if !@at_station || !@station
      fail ProhibitionError, "Train ##{@num} can't depart because it is not at a station."
    end
    if @route.first?(@station)
      fail ProhibitionError, "Train ##{@num} is at the starting point; can't move backward."
    end
    @station.release_train(self)
    @at_station = false
    @forward = false
    @station = @route.prev(@station)
  end

  def move_directly(station)
    unless station.valid?
      fail ProtectionError, "Train ##{@num} is directed to invalid station #{station.name}"
    end
    @station.release_train(self) if @at_station
    @at_station = true
    @station = station
    station.accept_train(self)
  end

  def assign_route(route)
    fail ProtectionError, "Invalid route is assigned to train ##{@num}" unless route.valid?
    if @station && @at_station && !route.include?(@station)
      fail ProhibitionError, "Before assigning the route, train ##{@num}"\
                              " must leave #{@station.name} which is not on the route."
    end
    @route = route
    @station = @route.first unless @at_station
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

  def to_s
    @num
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
    fail ProtectionError, "Wrong train format" unless self.class.correct_num_format?(@num)
    fail ProtectionError, "Unknown train type" unless correct_type?(@type)
    if self.class.get_by_number(@num)
      fail ProhibitionError, "Train with this number already exists"
    end
  end

end

