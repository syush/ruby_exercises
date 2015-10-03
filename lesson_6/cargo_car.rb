require_relative 'car'
  
class CargoCar < Car

  def initialize(capacity)
    super
    @type = :cargo
    @free_space = @capacity = capacity.to_f
  end

  def load(volume)
    if @free_space < volume
      puts "Error: can't load #{volume} m^3; only #{@free_space} m^3 of room is available"
    else
      @free_space -= volume
    end
  end

  def unload(volume)
    if @capacity - @free_space < volume
      puts "Error: can't unload #{volume} m^3; the car contains only #{@capacity - @free_space} m^3 of cargo"
    else
      @free_space += volume
    end
  end
end
