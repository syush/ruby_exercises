require_relative 'train'
require_relative 'station'
require_relative 'route'
require_relative 'passenger_car'
require_relative 'cargo_car'
require_relative 'car'
require_relative 'passenger_train'
require_relative 'cargo_train'

class Menu

def initialize
  @stations = {}
  @trains = {}
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
    if choice == "0"
      puts "Bye!"
      break
    elsif (choice_i > 0) && (choice_i <= menu_items.size)
      menu_items[choice_i - 1][:link].call
    else
      puts "Wrong menu choice; please try again."
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
  new_station = Station.new(name)
  @stations[name] = new_station
  puts "Station #{name} was successfully created."
end

def create_route
  puts "Let's create a route. Please enter the start station:"
  start = gets.chomp
  if !@stations[start] 
    puts "There is no such station. Please create a station first."
  else
    puts "Please enter the final destination:"
    final = gets.chomp
    if !@stations[final]
      puts "There is no such station. Please create a station first."
    else
      new_route = Route.new(@stations[start], @stations[final])
      @routes << new_route
      current = @stations[start]
      loop do
        puts "If you want to add a stop next after #{current.name}, enter its name, or type 'done' if there are no more stops."
        stop = gets.chomp
        break if stop == "done"
        if !@stations[stop]
          puts "There is no such station. Please create a station first."
        else
          new_route.add_station(@stations[stop], current)
          current = @stations[stop]
        end
      end
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
    puts "Operation failed: unknown car type"
  end
  @cars << car if car
  puts "Done" if car
end

def create_train
  puts "Let's create a train. Please enter its unique number:"
  num = gets.chomp
  puts "Please choose the train type: cargo (c) or passenger (p):"
  type = gets.chomp
  new_train = nil
  if ["C","CARGO"].include?(type.upcase)
    new_train = CargoTrain.new(num)
  elsif ["P","PASSENGER"].include?(type.upcase)
    new_train = PassengerTrain.new(num)
  else
    puts "Operation failed: unknown train type"
  end 
  @trains[num] = new_train if new_train  
  puts "Done" if new_train
end

def attach_car
  puts "Let's attach a car to a train. Please enter the train number:"
  train_num = gets.chomp
  if !@trains[train_num]
    puts "There is no train with this number. Please create a train first"
  else
    train = @trains[train_num]
    success = false
    @cars.each do |car| 
      if car.detached && train.type == car.type
        train.add_car(car)
        success = true
        break 
      end
    end
    if success
      puts "A car was successfully added to train ##{train_num}"
    else
      puts "There are no cars of this type available, please create new ones or detach from other trains."
    end
  end
end

def detach_car
  puts "Let's detach a car from a train. Please enter the train number:"
  num = gets.chomp
  if !@trains[num]
    puts "There is no train with this number."
  else
    @trains[num].remove_car
    puts "Done"
  end
end

def assign_route
  puts "Let's assign a route to train. Please enter the train number:"
  train_num = gets.chomp
  if !@trains[train_num]
    puts "There is no train with this number"
  elsif @routes.empty?
    puts "There are no routes available. Please create a route first."
  else
    puts "The following @routes are available:"
    @routes.each_with_index do |route, index|
      print index.to_s + ": "
      route.print_text  
      puts     
    end
    puts "Please select the route by entering its number:"
    route_num = gets.chomp.to_i
    if route_num >= 0 && route_num < @routes.size
      @trains[train_num].assign_route(@routes[route_num])
      puts "Done"
    else
      puts "Error: the route number is out of range."
    end
  end
end

def move_along_route
  puts "Let's move a train along its route. Please enter the train number:"
  train_num = gets.chomp
  if !@trains[train_num]
    puts "There is no train with this number."
  else 
    train = @trains[train_num]
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
end

def move_to_station
  puts "Let's move a train directly to a particular station. Enter the train number:"
  train_num = gets.chomp
  puts "Enter the station name:"
  station_name = gets.chomp
  if @trains[train_num] && @stations[station_name]
    @trains[train_num].move_directly(@stations[station_name])
    @trains[train_num].print_current_station
  else
    puts "Error: such station or train doesn't exist"
  end
end

def cargo_load_unload      
  puts "Let's load/unload a cargo car. Please enter the train number:"
  train_num = gets.chomp
  if !@trains[train_num]
    puts "There is no train with this number."
  elsif @trains[train_num].type != :cargo
    puts "Train #{train_num} is not a cargo train"
  else
    puts "Enter the car number:"
    car_num = gets.chomp.to_i
    train = @trains[train_num]
    if train.num_cars < car_num
      puts "There are only #{train.num_cars} cars in train ##{train_num}."
    else
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
        puts "I don't understand you."
      end
    end
  end
end
 
def passenger_on_off 
  puts "Let's deal with seats in passenger trains. Enter the train number:"
  train_num = gets.chomp
  if !@trains[train_num]
    puts "There is no train with this number."
  elsif @trains[train_num].type != :passenger
    puts "Train ##{train_num} is not a passenger train"
  else
    puts "Enter the car number:"
    car_num = gets.chomp.to_i
    train = @trains[train_num]
    if train.num_cars < car_num
      puts "Train ##{train_num} has only #{train.num_cars} cars."
    else
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
        puts "I don't understand you"
      end
    end
  end
end

def print_stations 
  if @stations.empty?
    puts "There are no stations currently. You may want to create them first."
  else
    puts "The total station list is below:"
    Station.print_all    
  end
end

def print_routes
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
  if @trains.empty?
    puts "There are no trains. You may want to create them first."
  else
    puts "The full list of trains is below:"
    puts "    Number    |      Type      | Number of cars"
    @trains.each {|key,value| puts "#{key.center(14)}|#{value.type.to_s.center(16)}| #{value.num_cars.to_s.center(16)}"}
  end
end

def print_trains_at_station
  puts "Please enter the station name:"
  name = gets.chomp
  if !@stations[name]
    puts "There is no such station."
  else
    @stations[name].print_trains
  end
end

def print_cars
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
