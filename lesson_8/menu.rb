require_relative 'train'
require_relative 'station'
require_relative 'route'
require_relative 'passenger_car'
require_relative 'cargo_car'
require_relative 'car'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'exceptions'

class Menu

def initialize
  @cars = []
  @routes = []
end

def main_menu
  menu_items = [
                {text:"Create a station",link:method(:create_station)},
                {text:"Create a route",link:method(:create_route)},
                {text:"Create a car",link:method(:create_car)}, 
                {text:"Create a train",link:method(:create_train)},
                {text:"Attach a car to a train",link:method(:attach_car)},
                {text:"Detach a car from a train",link:method(:detach_car)},
                {text:"Assign a route to a train",link:method(:assign_route)},
                {text:"Move a train along its route",link:method(:move_along_route)},
                {text:"Move a train directly to a particular station",link:method(:move_to_station)},
                {text:"Load/unload a cargo car",link:method(:cargo_load_unload)},
                {text:"Occupy/release a seat in a passenger car",link:method(:passenger_on_off)},
                {text:"Show the list of stations",link:method(:print_stations)},
                {text:"Show the list of routes",link:method(:print_routes)},
                {text:"Show the list of trains",link:method(:print_trains)},
                {text:"Show trains at a particular station",link:method(:print_trains_at_station)},
                {text:"Show the number of cars",link:method(:print_cars)} ]
  loop do
    puts 
    puts "Welcome to the main menu of the railway operating system!"
    puts "Choose a menu item by typing its number:"
    menu_items.each_with_index {|item, i| puts "#{i+1}: #{item[:text]}" }
    puts "0: Exit the program"
    choice = gets.chomp
    choice_i = choice.to_i
    begin
      if choice == "0"
        puts "Bye!"
        break
      elsif (choice_i > 0) && (choice_i <= menu_items.size)
        menu_items[choice_i - 1][:link].call
      else
        puts "Wrong menu choice; please try again."
      end
    rescue InputError => e
      puts "Please be careful in entering the data. The following error occurred:"
      puts e.message
      puts "Please try again..."
      retry
    rescue ProhibitionError => e
      puts "The requested operation is currently unavailable for the following reason:"
      puts e.message
    rescue ProtectionError => e
      puts "A dangerous class protection error occurred. Please contact the developer of the railway operation system."
      puts "Error description: " + e.message
      puts e.backtrace
    rescue StandardError => e
      puts "Unexpected error occurred. Please contact the developer."
      puts "Error description: " + e.message
      puts e.backtrace
    end
    puts
    puts "Press ENTER to return to the main menu..."
    gets    
  end
end

private

def create_station
  puts "Let's create a new station. Please enter its name:"
  name = gets.chomp
  raise InputError, "Wrong station name" if !Station.valid_name?(name)
  new_station = Station.new(name)
  puts "Station #{name} was successfully created."
end

def find_station(name)
  station = Station.get_by_name(name)
  raise InputError, "There is no station named #{name}. Please create a station first." if !station
  station
end

def create_route
  puts "Let's create a route. Please enter the start station:"
  start = get_from_user(:station)
  puts "Please enter the final destination:"
  final = get_from_user(:station)
  new_route = Route.new(start, final)
  @routes << new_route
  current = start
  loop do
    begin
      puts "If you want to add a stop next after #{current.name}, enter its name, or type 'done' if there are no more stops."
      input = gets.chomp
      break if input.upcase == "DONE"
      next_stop = find_station(input)
      new_route.add_station(next_stop, current)
      current = next_stop
    rescue InputError
      puts "Please be careful with entering station names."
      puts "Please try again"
      retry
    rescue ProhibitionError => e
      puts "The following problem appeared:"
      puts e.message
      puts "Please try again"
      retry
    end
  end
end

def create_car 
  puts "Let's create a car. Please choose its type: cargo (c) or passenger (p):"
  type = gets.chomp
  car = nil
  if ["C","CARGO"].include?(type.upcase)
    puts "Enter the capacity of the cargo car in m^3:"
    capacity = gets.chomp.to_f
    car = CargoCar.new(capacity)
  elsif ["P","PASSENGER"].include?(type.upcase)
    puts "Enter the number of seats in the passenger car:"
    seats = gets.chomp.to_i
    car = PassengerCar.new(seats)
  else
    raise InputError, "Unknown car type"
  end
  @cars << car
  puts "Done"
end

def create_train
  puts "Let's create a train. Please enter its unique number:"
  num = gets.chomp
  raise InputError, "Train number doesn't fit the required format" if !Train.correct_num_format?(num)
  puts "Please choose the train type: cargo (c) or passenger (p):"
  type = gets.chomp
  new_train = nil
  if ["C","CARGO"].include?(type.upcase)
    new_train = CargoTrain.new(num)
  elsif ["P","PASSENGER"].include?(type.upcase)
    new_train = PassengerTrain.new(num)
  else
    raise InputError, "Unknown train type"
  end 
  puts "Done"
end

def find_train(num)
  train = Train.get_by_number(num)
  raise InputError, "There is no train ##{num}. Please create a train first." if !train
  train
end

def get_from_user(item)
  key = gets.chomp
  case item 
  when :train 
    return find_train(key)
  when :station
    return find_station(key)
  end
end

def attach_car
  puts "Let's attach a car to a train. Please enter the train number:"
  train = get_from_user(:train)
  success = false
  @cars.each do |car| 
    if car.detached && train.type == car.type
      train.add_car(car)
      success = true
      break 
    end
  end
  raise ProhibitionError, "No cars of this type available, please create new ones or detach from other trains." if !success
  puts "A car was successfully added to train ##{train.num}"
end

def detach_car
  puts "Let's detach a car from a train. Please enter the train number:"
  train = get_from_user(:train)
  train.remove_car
  puts "Done"
end

def assign_route
  return "There are no routes available. Please create a route first." if @routes.empty?
  puts "Let's assign a route to train. Please enter the train number:"
  train = get_from_user(:train)
  puts "The following routes are available:"
  @routes.each_with_index do |route, index|
    print index.to_s + ": "
    route.print_text  
    puts     
  end
  puts "Please select the route by entering its number:"
  route_num = gets.chomp.to_i
  raise InputError, "The route number is out of range." if route_num < 0 || route_num >= @routes.size
  train.assign_route(@routes[route_num])
  puts "Done"
end

def move_along_route
  puts "Let's move a train along its route. Please enter the train number:"
  train = get_from_user(:train)
  if train.at_station
    train.print_current_station
    puts "Move forward (f) or backward (b)?"
    direction = gets.chomp
    if ["F","FORWARD"].include?(direction.upcase)
      train.depart_forward
      train.print_next_station
    elsif ["B", "BACKWARD"].include?(direction.upcase)
      train.depart_backward
      train.print_prev_station
    else
      raise InputError, "I don't understand you"
    end
  else
    puts "The train is currently moving. Should it arrive to the station (yes/no)?"
    answer = gets.chomp
    if ["Y","YES"].include?(answer.upcase)
      train.arrive
      train.print_current_station
    end
  end
end

def move_to_station
  puts "Let's move a train directly to a particular station. Enter the train number:"
  train = get_from_user(:train)
  puts "Enter the station name:"
  station = get_from_user(:station)  
  train.move_directly(station)
  train.print_current_station
end

def select_car(train)
  raise ProhibitionError, "Train ##{train.num} doesn't contain any cars." if train.num_cars == 0
  puts "Train ##{train.num} contains #{train.num_cars} cars currently."
  puts "Enter the car number:"
  car_num = gets.chomp.to_i
  raise ProhibitionError, "Car number is out of range." if train.num_cars < car_num || car_num < 1 
  car_num
end

def cargo_load_unload      
  puts "Let's load/unload a cargo car. Please enter the train number:"
  train = get_from_user(:train)
  raise ProhibitionError, "Train ##{train.num} is not a cargo train" if train.type != :cargo
  car_num = select_car(train)
  puts "Load (l) or unload (u)?"
  answer = gets.chomp
  car = train.cars[car_num-1]
  if ["L","LOAD"].include?(answer.upcase)
    puts "Enter the amount to load in m^3:"
    amount = gets.chomp.to_f 
    car.load(amount)
    puts "The car now has #{car.free_space} m^3 of free space."
  elsif ["U","UNLOAD"].include?(answer.upcase)
    puts "Enter the amount to unload in m^3:"
    amount = gets.chomp.to_f
    car.unload(amount)
    puts "The car now has #{car.free_space} m^3 of free space."
  else
    raise InputError, "I don't understand you."
  end
end
 
def passenger_on_off 
  puts "Let's deal with seats in passenger trains. Enter the train number:"
  train = get_from_user(:train)
  raise ProhibitionError, "Train ##{train.num} is not a passenger train" if train.type != :passenger
  car_num = select_car(train)
  puts "Do you want to occupy (o) or release (r) a seat?"
  answer = gets.chomp
  car = train.cars[car_num-1] 
  if ["O","OCCUPY"].include?(answer.upcase)
    car.occupy_seat
    puts "The car now has #{car.free_seats} free seats."
  elsif ["R","RELEASE"].include?(answer.upcase)
    car.release_seat
    puts "The car now has #{car.free_seats} free seats."
  else
    raise InputError, "I don't understand you"
  end
end

def print_stations 
  puts "Instance counter reports #{Station.instances} stations."
  if Station.none?
    puts "There are no stations currently. You may want to create them first."
  else
    puts "The total station list is below:"
    Station.print_all    
  end
end

def print_routes
  puts "Instance counter reports #{Route.instances} routes."
  if @routes.empty?
    puts "There are no routes currently. You may want to create them."
  else
    puts "The total list of routes is below:"
    @routes.each do |route| 
      route.print_text   
      puts
    end
  end     
end

def print_trains
  puts "Instance counter for trains equals #{Train.instances}."
  puts "Instance counter for passenger trains equals #{PassengerTrain.instances}."
  puts "Instance counter for cargo trains equals #{CargoTrain.instances}."
  if Train.none?
    puts "There are no trains. You may want to create them first."
  else
    puts "The full list of trains is below:"
    puts "#{"Number".center(14)}|#{"Type".center(16)}|#{"Number of cars".center(16)}"
    Train.all_trains.each do |key,value| 
      puts "#{key.center(14)}|#{value.type.to_s.center(16)}|#{value.num_cars.to_s.center(16)}"
    end
  end
end

def print_trains_at_station
  puts "Please enter the station name:"
  station = get_from_user(:station) 
  station.print_trains
end

def print_cars
  puts "Instance counter reports #{Car.instances} cars, #{CargoCar.instances} cargo cars, #{PassengerCar.instances} passenger cars."
  total_cargo = 0
  total_passenger = 0
  detached_cargo = 0
  detached_passenger = 0
  @cars.each do |car|
    total_cargo += 1 if car.type == :cargo
    total_passenger += 1 if car.type == :passenger
    detached_cargo += 1if car.type == :cargo && car.detached
    detached_passenger += 1 if car.type == :passenger && car.detached
  end
  puts "There are #{total_cargo} cargo cars; #{detached_cargo} of them are detached."
  puts "There are #{total_passenger} passenger cars; #{detached_passenger} of them are detached."
end

end
