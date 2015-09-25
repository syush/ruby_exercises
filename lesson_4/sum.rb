puts "This program calculates the sum and arithmetic average of all integers from 1 to N"
error = 1
while error == 1 do
  puts "Enter the value of N:"
  n = gets.chomp.to_i
  if n < 1
    puts "The number should be a positive integer"
  else
    error = 0
  end
end

sum = 0
for i in (1..n) do
  sum += i
end
average = sum.to_f / n
puts "Calculated with FOR loop: Sum = #{sum}, average = #{average}"

sum = 0
i = 0
while i <= n do
  sum += i
  i += 1
end
average = sum.to_f / n
puts "Calculated with WHILE loop: Sum = #{sum}, average = #{average}"

sum = 0
i = 0
until i > n do
  sum += i
  i += 1
end
average = sum.to_f / n
puts "Calculated with UNTIL loop: Sum = #{sum}, average = #{average}"

sum = 0
arr = (1..n).to_a
arr.each {|i| sum += i}
average = sum.to_f / n
puts "Calculated with EACH loop: Sum = #{sum}, average = #{average}" 

sum = 0
n.times {|i| sum += (i+1)}
average = sum.to_f / n
puts "Calculated with TIMES loop: Sum = #{sum}, average = #{average}"

