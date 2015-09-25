puts "This program calculates the factorial of N."
puts "Please enter the value of N:"
n = gets.chomp.to_i
if n < 0
  puts "N should be a non-negative integer."
else
  f = 1
  for i in (1..n) do
    f *= i
  end
  puts "#{n}! = #{f}"
end
