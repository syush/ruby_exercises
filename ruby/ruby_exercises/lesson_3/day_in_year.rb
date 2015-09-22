puts "Let's calculate the day number in a year"
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

case m
  when 1
    daynum = d
    error = 1 if daynum > 31
  when 2
    daynum = d + 31
    error = 1 if daynum > 28 + bissex
  when 3
    daynum = d + 59 + bissex
    error = 1 if daynum > 31 
  when 4
    daynum = d + 90 + bissex
    error = 1 if daynum > 30
  when 5
    daynum = d + 120 + bissex
    error = 1 if daynum > 31
  when 6
    daynum = d + 151 + bissex
    error = 1 if daynum > 30
  when 7 
    daynum = d + 181 + bissex
    error = 1 if daynum > 31
  when 8
    daynum = d + 212 + bissex
    error = 1 if daynum > 31
  when 9
    daynum = d + 243 + bissex
    error = 1 if daynum > 30
  when 10
    daynum = d + 273 + bissex
    error = 1 if daynum > 31
  when 11
    daynum = d + 304 + bissex
    error = 1 if daynum > 30
  when 12
    daynum = d + 334 + bissex
    error = 1 if daynum > 31
  else
    error = 1
end

error = 1 if daynum < 0

case daynum % 10
  when 1
    ending = "st"
  when 2
    ending = "nd"
  when 3
    ending = "rd"
  else
    ending = "th"
end

if error
  puts "There is no such day"
else
  puts "This day is the #{daynum.to_s + ending} day of the year."
  if bissex == 1 
    puts "The year is bissextile."
  end 
end   


