require_relative 'train'

class PassengerTrain < Train
  def initialize (num)
    init_num(num)
    init_type(:passenger)
    init_defaults
  end
end

