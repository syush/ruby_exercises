require_relative 'car'
require_relative 'exceptions'

class PassengerCar < Car

  attr_reader :free_seats
  
  def initialize(max_seats)
    super
    @type = :passenger
    @free_seats = @max_seats = max_seats.to_i
    validate!
  end

  def valid?
    car_valid = super
    car_valid &= (@max_seats > 0 && @free_seats >= 0 && @type == :passenger)
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

  private

  def validate!
    fail ProtectionError, "Non-positive passenger train capacity" if @max_seats <= 0
  end

end

