require_relative 'train'

class PassengerTrain < Train
  def initialize (num, num_cars)
    init_num(num)
    init_type(:passenger)
    init_num_cars(num_cars)
    init_defaults
  end
end

