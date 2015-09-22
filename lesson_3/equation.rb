puts "Let's solve a square equation: a*x^2 + b*x + c = 0."
puts "Please enter a:"
a = gets.chomp.to_f
puts "Please enter b:"
b = gets.chomp.to_f
puts "Please enter c:"
c = gets.chomp.to_f
d = b*b - 4*a*c;
puts "The discriminant equals #{d}."
if d < 0
  puts "The equation has no roots."
elsif d == 0
  root = -b / (2*a)
  puts "The equation has one root which equals #{root}."
else
  dsq = Math.sqrt(d)
  root1 = (-b - dsq) / (2*a)
  root2 = (-b + dsq) / (2*a)
  puts "The equation has two roots which equal #{root1} and #{root2}."
end

  
