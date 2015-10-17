require_relative 'car'
require_relative 'exceptions'
require_relative 'validate'

class CargoCar < Car

  include Validate

  attr_reader :free_space

  validate :capacity, :presence
  validate :free_space, :presence
  validate :capacity, :type, Float
  validate :capacity, :greater, 0
  validate :free_space, :greater_or_equal, 0
  validate :type, :equal, :cargo

  def initialize(capacity)
    super
    @type = :cargo
    @free_space = @capacity = capacity.to_f
    validate!
  end

  def current_load
    @capacity - @free_space
  end

  def load(volume)
    fail ProtectionError, "Non-positive volume is supposed to be loaded" if volume <= 0
    if @free_space < volume
      fail ProhibitionError, "Can't load #{volume} m^3;"\
                              " only #{@free_space} m^3 of room is available"
    end
    @free_space -= volume
  end

  def unload(volume)
    fail ProtectionError, "Non-positive volume is supposed to be unloaded" if volume <= 0
    if @capacity - @free_space < volume
      fail ProhibitionError, "Can't unload #{volume} m^3;"\
                              " the car contains only #{@capacity - @free_space} m^3 of cargo"
    end
    @free_space += volume
  end

end

