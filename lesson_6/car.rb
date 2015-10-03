class Car
  def initialize(seats_or_load)
    @num = 0
    @train = nil
  end

  attr_reader :type
 
  def attach(train, num)
    @num = num
    @train = train    
  end

  def detach
    @num = 0
    @train = nil
  end
end
