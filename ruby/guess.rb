#!/usr/bin/ruby
puts 'input a number 0 - 9'
res = rand(10)
while true
  guess = gets.to_i
  if guess < res
    puts 'low'
  elsif guess > res
    puts 'high'
  else
    puts 'bingo'
    break
  end
end
