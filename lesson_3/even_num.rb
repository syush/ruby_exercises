puts "Let's check whether a number is even or odd. Please enter the number:"
a = gets.chomp.to_i
if a % 2 == 0
  puts "#{a} is an even number"
else
  puts "#{a} is an odd number"
end
