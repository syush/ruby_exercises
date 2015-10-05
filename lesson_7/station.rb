require_relative 'train'

class Station
  
  @@all_stations = []

  def self.print_all
    @@all_stations.each {|name| puts name}
  end
  
  def initialize (name)
    @name = name
    @train_list = []
    @@all_stations << name
  end
 
  attr_reader :name
  
  def accept_train (train)
    if @train_list.include?(train)
      puts "Error: station #{@name} trying to accept train ##{train.num} which is already there"
    else
      @train_list << train
    end
  end

  def print_trains
    if @train_list.empty?
      puts "There are no trains at station #{@name}."
    else
      puts "The following trains are currently at station #{@name}:"
      @train_list.each {|train| puts "Train ##{train.num} (#{train.type})"}
    end
  end

  def print_trains_per_type
    trains_per_type = {passenger:[], cargo:[]}
    @train_list.each {|train| trains_per_type[train.type] << train}
    [:passenger, :cargo].each do |type|
      n = trains_per_type[type].size
      if n == 0
        puts "There are no #{type} trains at station #{@name}."
      else
        puts "There #{n==1 ? "is" : "are"} #{n} #{type} train#{n==1 ? "" : "s"} at station #{@name}:"
        trains_per_type[type].each {|train| puts "Train ##{train.num}"}
      end
    end
  end

  def release_train (train)
    if @train_list.include?(train)
      @train_list.delete(train)
    else
      puts "Error: station #{@name} trying to release train ##{train.num} which is not there"
    end
  end     
end


