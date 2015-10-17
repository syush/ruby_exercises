require_relative 'producer'
require_relative 'instance_counter'
require_relative 'exceptions'
require_relative 'validate'

class Car

  include InstanceCounter
  include Producer
  include Validate

  attr_reader :type
  attr_reader :num

  validate :num, :type, Fixnum
  validate :num, :greater_or_equal, 0

  def initialize(seats_or_load)
    @num = 0
    @train = nil
    register_instance
  end

  def attach(train, num)
    fail ProtectionError, "Car attachted to invalid train ##{train.num}" unless train.valid?
    fail ProtectionError, "Car was assigned non-positive number #{num}" if num <= 0
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

