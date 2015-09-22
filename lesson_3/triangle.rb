puts "Let's check whether a triangle is isolateral/isosceles/rightangled."
puts "Enter the length of the 1st side:"
a = gets.chomp.to_f
puts "Enter the length of the 2nd side:"
b = gets.chomp.to_f
puts "Enter the length of the 3rd side:"
c = gets.chomp.to_f
if (a == b) && (b == c)
  puts "The triangle is isolateral (равносторонний)."
elsif (a == b) || (b == c) || (a == c)
  puts "The triangle is isosceles (равнобедренный)"
else
  puts "The triangle is neither isolateral nor isosceles (не является ни равнобедренным, ни равносторонним)."
end
if (a > b) && (a > c) 
  hyp = a
  cat1 = b
  cat2 = c
elsif (b > a) && (b > c)
  hyp = b
  cat1 = a
  cat2 = c
elsif (c > a) && (c > b)
  hyp = c
  cat1 = a
  cat2 = b
end
if hyp && (hyp**2 == cat1**2 + cat2**2)
  puts "The triangle is rightangled (прямоугольный)."
else
  puts "The triangle is not rightangled (не является прямоугольным)."
end
  
  
