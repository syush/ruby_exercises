puts "Let's check whether a triangle is isolateral or isosceles."
puts "Enter the length of the 1st side:"
a = gets.chomp.to_f
puts "Enter the length of the 2nd side:"
b = gets.chomp.to_f
puts "Enter the length of the 3rd side:"
c = gets.chomp.to_f
if (a == b) && (b == c)
  puts "The triangle is isolateral (равнобедренный)."
elsif (a == b) || (b == c) || (a == c)
  puts "The triangle is isosceles (равносторонний)"
else
  puts "The triangle is neither isolateral nor isosceles (не является ни равнобедренным, ни равносторонним)."
end
