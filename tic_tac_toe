require_relative 'game'
require_relative 'player'

puts "What is the first player's name? (You will be playing X)"
player1 = Player.new(gets.chomp, 'X')
puts "What is the second player's name? (You will be playing O)"
player2 = Player.new(gets.chomp, 'O')

game = Game.new(player1, player2)
loop do
  break if game.play_round(0) == 'END'
  break if game.play_round(1) == 'END'
end
