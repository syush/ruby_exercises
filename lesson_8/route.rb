require_relative 'station'
require_relative 'instance_counter'
require_relative 'exceptions'


class Route

  include InstanceCounter
  def initialize(first, last)
    @list = [first, last]
    validate!
    @cur_index = 0
    register_instance
  end

  def add_station(new_station, prev_station)
    raise ProtectionError, "A non-station trying to be inserted to the route" if !new_station.respond_to?(:accept_train)
    raise ProtectionError, "Invalid station #{new_station.name} trying to be inserted to the route" if !new_station.valid?
    raise ProtectionError, "Route doesn't contain station #{prev_station.name}" if !@list.include?(prev_station)
    raise ProhibitionError, "Route already contains station #{new_station.name}" if @list.include?(new_station)
    @list.insert(@list.index(prev_station) + 1, new_station)
  end
  
  def remove_station(station)
    raise ProhibitionError, "Can't remove #{station.name} from the route since it's not there"  if @list.include?(station)
    @list.delete(station)
  end

  def first
    @list.first
  end
  
  def last
    @list.last
  end

  def first?(station)
    @list.first == station
  end

  def last?(station)
    @list.last == station
  end

  def next(station)
    raise ProhibitionError, "Station #{station.name} is not on the route" if !@list.include?(station)
    @list[@list.index(station) + 1]
  end

  def prev(station)
    raise ProhibitionError, "Station #{station.name} is not on the route" if !@list.include?(station)
    @list[@list.index(station) - 1]
  end

  def include?(station)
    @list.include?(station)
  end

  def print_text
    text = ""
    @list.each {|station| text += "-" + station.name + "-"}
    print text
  end

  def valid?
    true
  end

private

  def validate!
    @list.each do |station| 
      raise ProtectionError, "Invalid station #{station.name} added to route" if !station.respond_to?(:accept_train) || !station.valid?
    end
    raise ProtectionError, "Start and final stations are the same station." if @list.first == @list.last
  end

end
