puts "This program creates a hash with the list of purchases and calculates the total price."
hash = {}
puts "So let's start entering the list of your purchases now."
while true do
  puts "Enter the name of the purchase (or type 'stop' if you're done):"
  name = gets.chomp
  break if name == "stop" 
  puts "Enter the amount of '#{name}':"
  am = gets.chomp.to_f
  error = 1 if am < 0
  puts "Enter the price of '#{name}':"
  pr = gets.chomp.to_f
  error = 1 if pr < 0
  hash [name] = {amount:am, price:pr}
  break if error
end
if error
  puts "Amount and price must be non-negative numbers."
else
  puts "Here is your check:"
  puts "       Name                             |    Amount    |    Price     |  Subtotal    |"
  total = 0
  hash.each do |key, value|
    subtotal = value[:amount] * value[:price]
    total += subtotal
    puts "#{key.ljust(40)}|  #{value[:amount].to_s.rjust(11)} |  #{value[:price].to_s.rjust(11)} |  #{subtotal.to_s.rjust(11)} |"
  end
  puts "The total price is #{total}"
end
    

