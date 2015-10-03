require_relative 'car'
  
class CargoCar < Car

  def initialize
    super
    @type = :cargo
  end

end
