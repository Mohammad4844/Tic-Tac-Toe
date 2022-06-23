class Game
  def initialize(player1, player2)
    @board = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    @players = [player1, player2]
    print_board
  end

  public

  def play_round(i)
    player = @players[i]
    puts "#{player.name}, choose a position to place a #{player.selector}"
    begin
      position = gets.to_i
      raise 'Errorz' if position < 1 || position > 9 || @board[position - 1] == 'X' || @board[position - 1] == 'O'
    rescue
      puts 'Enter a correct position'
      retry
    else
      update_board(position, player.selector)
    end
  end

  private

  def update_board(position, selector)
    change_cell(position, selector)
    winner_selector = check_for_winner
    print_board
    end_game_with_winner(winner_selector) if winner_selector
  end

  def end_game_with_winner(winner_selector)
    winner = @players.find { |player| player.selector == winner_selector }
    puts "\n#{winner.name} won!\n\n"
    'END'
  end

  def change_cell(position, selector)
    @board[position - 1] = selector
  end

  def check_for_winner
    win_combinations = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
    win_combinations.each do |comb|
      return @board[comb[0]] if @board[comb[0]] == @board[comb[1]] && @board[comb[1]] == @board[comb[2]]
    end
    nil
  end

  def print_board
    puts ''
    puts "#{@board[0]} | #{@board[1]} | #{@board[2]}"
    puts '--+---+--'
    puts "#{@board[3]} | #{@board[4]} | #{@board[5]}"
    puts '--+---+--'
    puts "#{@board[6]} | #{@board[7]} | #{@board[8]}"
    puts ''
  end
end
