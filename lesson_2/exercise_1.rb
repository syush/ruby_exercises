puts "Hi, what's your name?"
name = gets.chomp
puts "Could you please type your height in centimeters:"
height = gets.chomp.to_i
puts "#{name}, your optimal weight is #{height - 110} kg."
