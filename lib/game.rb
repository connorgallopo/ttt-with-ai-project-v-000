class Game
  attr_accessor :board, :player_1, :player_2
  WIN_COMBINATIONS =
  [[0, 1, 2],
   [3, 4, 5],
   [6, 7, 8],
   [0, 3, 6],
   [1, 4, 7],
   [2, 5, 8],
   [0, 4, 8],
   [2, 4, 6]]

  def initialize(player_1 = Players::Human.new('X'), player_2 = Players::Human.new('O'), board = Board.new)
    @board = board
    @player_1 = player_1
    @player_2 = player_2
  end

  def current_player
    @board.turn_count.even? ? @player_1 : @player_2
  end

  def over?
    won? || draw?
  end

  def draw?
    !won? && board.full?
  end

  def won?(board = @board)
    WIN_COMBINATIONS.detect do |win_combination|
      win_index_1 = win_combination[0]
      win_index_2 = win_combination[1]
      win_index_3 = win_combination[2]
      position_1 = board.cells[win_index_1]
      position_2 = board.cells[win_index_2]
      position_3 = board.cells[win_index_3]

      position_1 == position_2 && position_2 == position_3 && board.taken?(win_index_1 + 1)
    end
  end

  def winner
    @board.cells[won?.first] if won?
  end

  def turn
    player = current_player
    move = player.move(board)
    if !@board.valid_move?(move)
      puts "Invalid Move"
      turn
    else
      @board.update(move, player)
      puts "#{player.token} made turn #{@board.turn_count}"
      @board.display
    end
  end

  def play
    until over?
      turn
    end
    if won?
      puts "Congratulations #{winner}!"
    elsif draw?
      puts "Cat's Game!"
    end
  end
end