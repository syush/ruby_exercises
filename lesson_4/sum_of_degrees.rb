puts "This program calculates the sum of X^X degrees of integers from 1 to N (i.e. 1^1 + 2^2 + 3^3 +...+ N^N)."
puts "Enter the value of N:"
n = gets.chomp.to_i
if n < 1
  puts "N should be a positive integer."
else
  s = 0
  for i in (1..n) do
    s += i**i
  end
  puts "The sum of X^X degrees of integers 1 to #{n} equals #{s}."
end
