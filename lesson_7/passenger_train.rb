require_relative 'train'

class PassengerTrain < Train
  def initialize (num)
    super(num, :passenger)
  end
end

