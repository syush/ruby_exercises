puts "This program will fill an array with Fibonacci numbers not exceeding 100."
arr = []
arr << 1
f = 1
i = 1
while f < 100 do
  arr << f
  f = arr[i] + arr[i-1]
  i += 1
end
puts "Done! Now the array looks like this:"
arr.each {|f| print " #{f}"}
puts
