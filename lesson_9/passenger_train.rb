require_relative 'train'
require_relative 'exceptions'


class PassengerTrain < Train
  def initialize (num)
    super(num, :passenger)
  end
end

