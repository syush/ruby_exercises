puts "This program will fill an array with all numbers between 10 and 100 with the step of 5."
a = []
i = 10
while i <= 100 do
  a << i
  i += 5
end
puts "Done! Now the array looks like this:"
a.each {|i| print " #{i}"}
puts
  
