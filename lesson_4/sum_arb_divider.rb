puts "This program calculates the sum and arithmetic average of all integers from 1 to N which are multiples of K"
error = 1
while error == 1 do
  puts "Enter the value of N:"
  n = gets.chomp.to_i
  puts "Enter the value of K:"
  k = gets.chomp.to_i
  if n < 1 || k < 1
    puts "The numbers should be a positive integers"
  else
    error = 0
  end
end

sum = 0
for i in (1..n/k) do
  sum += i * k
end
average = sum.to_f / (n / k)
puts "Calculated with FOR loop: Sum = #{sum}, average = #{average}"

sum = 0
i = 0
while i <= n do
  sum += i
  i += k
end
average = sum.to_f / (n / k)
puts "Calculated with WHILE loop: Sum = #{sum}, average = #{average}"

sum = 0
i = 0
until i > n do
  sum += i
  i += k
end
average = sum.to_f / (n / k)
puts "Calculated with UNTIL loop: Sum = #{sum}, average = #{average}"

sum = 0
arr = (1..(n/k)).to_a
arr.each {|i| sum += i*k}
average = sum.to_f / (n / k)
puts "Calculated with EACH loop: Sum = #{sum}, average = #{average}" 

sum = 0
(n/k).times {|i| sum += (i+1) * k} 
average = sum.to_f / (n / k)
puts "Calculated with TIMES loop: Sum = #{sum}, average = #{average}"
