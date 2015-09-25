puts "This program creates a hash with the number of days in a month and prints months having exactly 30 days."
days_per_month = {January:31, February:28, March:31, April:30, May:31, June:30, 
                  July:31, August:31, September:30, October:31, November:30, December:31}
puts "The list of such months is below:"
days_per_month.each do |key,value|
  if value == 30
    print "#{key} "
  end
end
puts
