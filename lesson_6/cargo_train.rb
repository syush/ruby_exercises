require_relative 'train'

class CargoTrain < Train
  def initialize (num)
    init_num(num)
    init_type(:cargo)
    init_defaults
  end
end

