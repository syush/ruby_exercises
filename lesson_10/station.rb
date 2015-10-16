require_relative 'train'
require_relative 'instance_counter'
require_relative 'exceptions'
require_relative 'meta_accessors'

class Station

  include InstanceCounter
  extend MetaAccessors

  attr_reader :name
  attr_accessor_with_history :manager
  strong_attr_accessor :manager_appoint_year, Fixnum

  @@all_stations = {}

  def self.print_all
    @@all_stations.each { |key,value| puts key }
  end

  def self.get_by_name(name)
    station = @@all_stations[name]
  end

  def self.none?
    @@all_stations == {}
  end

  def self.valid_name?(name)
    if name =~ /\A([A-Z]([A-Z]*|[a-z]*)|\d+)(( |-)([A-Z]?([A-Z]*|[a-z]*)|d+))*\z/
      latin_name = true
    end
    if name =~ /\A([А-Я]([А-Я]*|[а-я]*)|\d+)(( |-)([А-Я]?([А-Я]*|[а-я]*)|d+))*\z/
      cyrillic_name = true
    end
    latin_name || cyrillic_name
  end

  def initialize (name)
    @name = name
    validate!
    @train_list = []
    @@all_stations[name] = self
    register_instance
  end

  def valid?
    self.class.valid_name?(@name)
  end

  def each_train
    @train_list.each { |train| yield(train) }
  end

  def accept_train (train)
    if @train_list.include?(train)
      fail ProhibitionError, "Station #{@name} trying to accept train ##{train.num}"\
                              " which is already there"
    end
    unless train.valid?
      fail ProtectionError, "Invalid train #{train.num} requests acceptance by station #{@name}"
    end
    @train_list << train
  end

  def print_trains
    if @train_list.empty?
      puts "There are no trains at station #{@name}."
    else
      puts "The following trains are currently at station #{@name}:"
      each_train { |train| puts "Train ##{train.num} (#{train.type})" }
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
        puts "There #{n==1 ? "is" : "are"} #{n} #{type} train#{n==1 ? "" : "s"}"\
             " at station #{@name}:"
        trains_per_type[type].each { |train| puts "Train ##{train.num}" }
      end
    end
  end

  def release_train (train)
    unless @train_list.include?(train)
      fail ProhibitionError, "Station #{@name} trying to release train ##{train.num}"\
                              " which is not there"
    end
    @train_list.delete(train)
  end

  def to_s
    @name
  end

  private

  def validate!
    fail ProtectionError, "Strange station name" unless self.class.valid_name?(@name)
  end

end

