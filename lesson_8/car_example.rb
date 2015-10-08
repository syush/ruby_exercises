class Car

  INITIAL_PRM = 700
  attr_reader :current_rpm

  def initialize 
    @current_rpm = 0
  end

  def start_engine
    start_engine! if engine_stopped?
  end

  def engine_stopped?
    @current_rpm.zero?
  end

  def initial_rpm
    700
  end

  private

  attr_writer :current_rpm

  def start_engine!
    @current_rpm = initial_rpm
  end
end

class SportCar < Car
  def initial_rpm
    1000
  end

  def start_engine
    puts "Wroom!"
    super
  end
end

class Truck < Car
  def loading
  end
end
