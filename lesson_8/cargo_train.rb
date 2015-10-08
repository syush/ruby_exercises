require_relative 'train'

class CargoTrain < Train
  def initialize (num)
    super(num, :cargo)
  end
end

