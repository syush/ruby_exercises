require_relative 'train'

class CargoTrain < Train
  def initialize (num, num_cars)
    init_num(num)
    init_type(:cargo)
    init_num_cars(num_cars)
    init_defaults
  end
end

