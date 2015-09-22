puts "Now let's see how we call days of the week."
puts "Please enter the order number of the day in the week:"
num = gets.chomp.to_i
case num
  when 1 
    name = "Monday (понедельник)"
    ending = "st"
  when 2 
    name = "Tuesday (вторник)"
    ending = "nd"
  when 3 
    name = "Wednesday (cреда)"
    ending = "rd"
  when 4 
    name = "Thursday (четверг)"
  when 5 
    name = "Friday (пятница)"
  when 6 
    name = "Saturday (суббота)"
  when 7 
    name = "Sunday (воскресенье)"
end
ending = "th" unless ending 
if name 
  puts "The #{num.to_s + ending} day of the week is #{name}."
else
  puts "The week day number must be an integer number between 1 and 7."
end 
