puts "Let's calculate the day number in a year."
puts "Enter the day number in the month:"
d = gets.chomp.to_i
puts "Enter the month number:"
m = gets.chomp.to_i
puts "Enter the year:"
y = gets.chomp.to_i

if ((y % 4 == 0) && (y % 100 != 0)) || (y % 400 == 0)
  bissex = 1
else  
  bissex = 0
end

d_per_m = [31, 28 + bissex, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

error = (y <= 0) || (m <= 0) || (m > 12) || (d <= 0) || (d > d_per_m[m-1])

if error
  puts "There is no such day"
else
  daynum = 0
  for i in (1..m-1) do
    daynum += d_per_m[i-1]
  end
  daynum += d 

  ending = {1 => "st", 2 => "nd", 3 => "rd", 4 => "th", 5 => "th", 6 => "th", 7 => "th", 8 => "th", 9 => "th", 0 => "th"}

  puts "This day is the #{daynum.to_s + ending[daynum % 10]} day of the year."
  if bissex == 1 
    puts "The year is bissextile."
  end 
end   


