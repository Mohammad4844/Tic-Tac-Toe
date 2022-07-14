require_relative '../lib/game'

describe Game do
  let(:player_X) { double('player', { selector: 'X', name: 'Ali' }) }
  let(:player_O) { double('player', { selector: 'O', name: 'Sam' }) }

  before do
    allow_any_instance_of(Game).to receive(:print_board)
  end

  describe '#play_round' do
    subject(:game_round) { described_class.new(player_X, player_O) }

    before do
      allow(game_round).to receive(:puts)
      allow(game_round).to receive(:update_board)
    end

    context 'when invalid input is given once, then correct input' do
      before do
        invalid_num = 100
        valid_input = 5
        allow(game_round).to receive(:gets).and_return(invalid_num, valid_input)
      end

      it 'gives error message once' do
        expect(game_round).to receive(:puts).with('Enter a valid position').once
        game_round.play_round(1)
      end
    end

    context 'when invalid input is given 3 times, then correct input' do
      before do
        invalid_num = -5
        symbol = '$'
        char = -5
        valid_input = 1
        allow(game_round).to receive(:gets).and_return(invalid_num, symbol, char, valid_input)
      end

      it 'gives error message 3 times' do
        expect(game_round).to receive(:puts).with('Enter a valid position').exactly(3).times
        game_round.play_round(1)
      end
    end

    context 'when correct input is givem' do
      before do
        valid_input = 8
        allow(game_round).to receive(:gets).and_return(valid_input)
      end

      it 'updates the board' do
        expect(game_round).to_not receive(:puts).with('Enter a valid position')
        game_round.play_round(1)
      end
    end
  end

  describe '#update_board' do
    subject(:game_update) { described_class.new(player_X, player_O) }

    it 'changes cell with the selector' do
      position = 3; selector = 'X'
      expect(game_update).to receive(:change_cell)
      game_update.update_board(position, selector)
    end

    it 'prints the board' do
      position = 3; selector = 'X'
      expect(game_update).to receive(:print_board)
      game_update.update_board(position, selector)
    end

    context 'if there is a winner' do
      before do
        allow(game_update).to receive(:check_for_winner).and_return('X')
      end

      it 'ends game with winner' do
        position = 3; selector = 'X'
        expect(game_update).to receive(:end_game_with_winner).with(selector)
        game_update.update_board(position, selector)
      end
    end

    context 'if the game is tied' do
      before do
        allow(game_update).to receive(:check_for_winner).and_return(false)
        allow(game_update).to receive(:full?).and_return(true)
      end

      it 'ends game with a tie' do
        position = 3; selector = 'X'
        expect(game_update).to receive(:end_game_with_tie)
        game_update.update_board(position, selector)
      end
    end

    context 'if there is no winner or tie' do
      before do
        allow(game_update).to receive(:check_for_winner).and_return(false)
        allow(game_update).to receive(:full?).and_return(false)
      end

      it 'game continues' do
        position = 3; selector = 'X'
        expect(game_update).to_not receive(:end_game_with_tie)
        expect(game_update).to_not receive(:end_game_with_winner)
        game_update.update_board(position, selector)
      end
    end
  end

  describe '#full' do
    subject(:game_fill) { described_class.new(player_X, player_O) }

    context 'if board is full' do
      before do
        game_fill.board.map! { 'X' }
      end

      it 'returns true' do
        expect(game_fill).to be_full
      end
    end

    context 'if board is empty' do
      it 'returns false' do
        expect(game_fill).to_not be_full
      end
    end

    context 'if board is filled but not completely' do
      before do
        game_fill.board = [1, 'X', 3, 'O', 'O', 'O', 7, 8, 9]
      end

      it 'returns false' do
        expect(game_fill).to_not be_full
      end
    end
  end

  describe '#change_cell' do
    subject(:game_cell) { described_class.new(player_X, player_O) }

    it 'changes position to X' do
      position = 3; selector = 'X'
      expect { game_cell.change_cell(position, selector) }.to change { game_cell.board[position - 1] }.to(selector)
    end

    it 'changes position to $' do
      position = 5; selector = '$'
      expect { game_cell.change_cell(position, selector) }.to change { game_cell.board[position - 1] }.to(selector)
    end
  end

  describe '#check_for_winner' do
    subject(:game_check) { described_class.new(player_X, player_O) }

    context 'when X wins' do
      before do
        game_check.board = ['X', 2, 3, 4, 'X', 6, 7, 8, 'X']
      end

      it 'returns X' do
        result = game_check.check_for_winner
        expect(result).to eq('X')
      end
    end

    context 'when there is no winner' do
      before do
        game_check.board = ['X', 'X', 3, 4, 'O', 6, 7, 8, 'X']
      end

      it 'returns nil' do
        result = game_check.check_for_winner
        expect(result).to be_nil
      end
    end
  end
end
