require_relative 'producer'
require_relative 'instance_counter'

class Car

  include InstanceCounter
  extend InstanceCounter
  def initialize(seats_or_load)
    @num = 0
    @train = nil
    register_instance
  end

  include Producer
  
  attr_reader :type
 
  def attach(train, num)
    @num = num
    @train = train    
  end

  def detach
    @num = 0
    @train = nil
  end

  def detached
    @num == 0
  end
end
