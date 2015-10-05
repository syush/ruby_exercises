require_relative 'station'

class Route
  def initialize(first, last)
    @list = [first, last]
    @cur_index = 0
  end

  def add_station(new_station, prev_station)
    if @list.include?(prev_station)
      @list.insert(@list.index(prev_station) + 1, new_station)
    else
      puts "Error: can't insert #{new_station.name} since the route doesn't contain #{prev_station.name}"
    end
  end
  
  def remove_station(station)
    if @list.include?(station)
      @list.delete(station)
    else
      puts "Error: can't remove #{station.name} from the route since it's not there"
    end
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
    @list[@list.index(station) + 1]
  end

  def prev(station)
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
end
