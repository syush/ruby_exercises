require_relative 'station'
require_relative 'instance_counter'
require_relative 'exceptions'
require_relative 'validate'

class Route

  include InstanceCounter
  include Validate

  validate :list, :each_type, Station
  validate :list, :each_valid
  validate :list, :unique_elements

  def initialize(first, last)
    @list = [first, last]
    validate!
    @cur_index = 0
    register_instance
  end

  def add_station(new_station, prev_station)
    unless new_station.respond_to?(:accept_train)
      fail ProtectionError, "A non-station trying to be inserted to the route"
    end
    unless new_station.valid?
      fail ProtectionError, "Invalid station #{new_station.name} trying insertion to the route"
    end
    unless @list.include?(prev_station)
      fail ProtectionError, "Route doesn't contain station #{prev_station.name}"
    end
    if @list.include?(new_station)
      fail ProhibitionError, "Route already contains station #{new_station.name}"
    end
    @list.insert(@list.index(prev_station) + 1, new_station)
  end

  def remove_station(station)
    if @list.include?(station)
      fail ProhibitionError, "Can't remove #{station.name} from the route since it's not there"
    end
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
    unless @list.include?(station)
      fail ProhibitionError, "Station #{station.name} is not on the route"
    end
    @list[@list.index(station) + 1]
  end

  def prev(station)
    unless @list.include?(station)
      fail ProhibitionError, "Station #{station.name} is not on the route"
    end
    @list[@list.index(station) - 1]
  end

  def include?(station)
    @list.include?(station)
  end

  def print_text
    print to_s 
  end

  def to_s
    @list.map(&:name).join('--')
  end

end

