class Car
  def initialize
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
  end
end
