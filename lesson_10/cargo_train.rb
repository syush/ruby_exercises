require_relative 'train'
require_relative 'exceptions'

class CargoTrain < Train
  def initialize (num)
    super(num, :cargo)
  end
end

