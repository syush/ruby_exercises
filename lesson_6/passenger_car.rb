require_relative 'car'

class PassengerCar < Car
  def initialize
    super
    @type = :passenger
  end
  
end
