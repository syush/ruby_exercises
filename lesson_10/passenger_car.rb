require_relative 'car'
require_relative 'exceptions'
require_relative 'validate'

class PassengerCar < Car

  include Validate

  attr_reader :free_seats
 
  validate :max_seats, :presence
  validate :free_seats, :presence
  validate :max_seats, :type, Fixnum 
  validate :max_seats, :greater, 0
  validate :free_seats, :greater_or_equal, 0
  validate :type, :equal, :passenger

  def initialize(max_seats)
    super
    @type = :passenger
    @free_seats = @max_seats = max_seats
    validate!
  end

  def occupied_seats
    @max_seats - @free_seats
  end

  def occupy_seat
    fail ProhibitionError, "Are you from Basseynaya St?" unless @train
    fail ProhibitionError, "Car ##{@num} of train ##{@train.num} is full" if @free_seats <= 0
    @free_seats -= 1
  end

  def release_seat
    fail ProhibitionError, "Car is empty" if @free_seats == @max_seats
    @free_seats += 1
  end

end

