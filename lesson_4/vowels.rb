puts "This program creates a hash with the order number of each vowel in the alphabet."
all_letters = ('A'..'Z').to_a
vowels = ['A', 'E', 'I', 'O', 'U', 'Y']
hash = {}
vowels.each {|v| hash[v] = all_letters.index(v) + 1}
puts "Now the hash contains the following information:"
hash.each {|key, value| puts "The letter #{key} is at position #{value} in the alphabet."}   
