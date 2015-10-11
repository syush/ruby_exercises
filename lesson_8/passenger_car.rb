require_relative 'car'
require_relative 'exceptions'


class PassengerCar < Car
  def initialize(max_seats)
    super
    @type = :passenger
    @free_seats = @max_seats = max_seats.to_i
    validate!
  end

  attr_reader :free_seats

  def valid?
    car_valid = super
    car_valid &= (@max_seats > 0 && @free_seats >= 0 && @type == :passenger)
  end
 
  def occupied_seats
    @max_seats - @free_seats
  end
 
  def occupy_seat
    raise ProhibitionError, "Are you from Basseynaya St?" if !@train
    raise ProhibitionError, "Car ##{@num} of train ##{@train.num} is full" if @free_seats <= 0
    @free_seats -= 1
  end

  def release_seat
    raise ProhibitionError, "Car is empty" if @free_seats == @max_seats
    @free_seats += 1
  end

private

  def validate!
    raise ProtectionError, "Non-positive passenger train capacity" if @max_seats <= 0
  end 

end
