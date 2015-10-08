require_relative 'car'

class PassengerCar < Car
  def initialize(max_seats)
    super
    @type = :passenger
    @free_seats = @max_seats = max_seats.to_i
  end

  attr_reader :free_seats

  def occupied_seats
    @max_seats - @free_seats
  end
 
  def occupy_seat
    if !@train
      puts "Are you from Basseynaya St?"
    elsif @free_seats > 0
      @free_seats -= 1
    else
      puts "Error: car ##{@num} of train ##{@train.num} is full"
    end
  end

  def release_seat
    if @free_seats == @max_seats
      puts "Error: car is empty"
    else
      @free_seats += 1
    end
  end



   
end
