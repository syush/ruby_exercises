require_relative 'car'
require_relative 'exceptions'

  
class CargoCar < Car

  def initialize(capacity)
    super
    @type = :cargo
    @free_space = @capacity = capacity.to_f
    validate!
  end

  attr_reader :free_space
 
  def valid?
    car_valid = super
    car_valid &= (@capacity > 0 && @free_space >= 0 && @type == :cargo)
  end
 
  def current_load
    @capacity - @free_space
  end
  
  def load(volume)
    raise ProtectionError, "Non-positive volume is supposed to be loaded" if volume <= 0
    raise ProhibitionError, "Can't load #{volume} m^3; only #{@free_space} m^3 of room is available" if @free_space < volume
    @free_space -= volume
  end

  def unload(volume)
    raise ProtectionError, "Non-positive volume is supposed to be unloaded" if volume <= 0
    raise ProhibitionError, "Can't unload #{volume} m^3; the car contains only #{@capacity - @free_space} m^3 of cargo" if @capacity - @free_space < volume
    @free_space += volume
  end

private

  def validate!
    raise ProtectionError, "Non-positive cargo train capacity" if @capacity <= 0
  end

end
