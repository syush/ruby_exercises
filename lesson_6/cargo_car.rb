require_relative 'car'
  
class CargoCar < Car

  def initialize(max_load)
    super
    @type = :cargo
    @max_load = max_load
  end

end
