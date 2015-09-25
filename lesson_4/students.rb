puts "Let's calculate the average score of students in the group."
puts "Enter the total number of students in the group:"
stnum = gets.chomp.to_i
if stnum > 0
  scores = []
  for i in (0..stnum-1) do
    puts "Enter the score for student ##{i+1}:"
    scores[i] = gets.chomp.to_i
    if scores[i] <= 0 || scores[i] > 100 
      error = 1
      break
    end
  end
  if error 
    puts "Error: each score should be an integer between 1 and 100."
  else
    sum = 0
    scores.each {|score| sum += score}
    avg = sum.to_f / stnum
    puts "The average score equals #{avg}."
  end
else
  puts "Error: the total number of students should be a positive integer."
end

  
