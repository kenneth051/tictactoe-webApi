# frozen_string_literal: true

class FakeGame
  attr_accessor :board

  def initialize(board, endgame = false, win = nil, symbol = nil)
    @board = board
    @endgame = endgame
    @symbol = symbol
    @win = win
  end

  def end?
    @endgame
  end

  def win?
    return { message: "Player using '#{@symbol}' has won!" } if @win
  end

  def draw?
    { message: " IT'S A DRAW!" }
  end
end

class WebApiGame
  def initialize(game, io = nil, validate = nil); end

  def validate_symbol(_input)
    @validate_symbol = true
  end

  def validate_symbol_is_called
    @validate_symbol
  end

  def play(input)
    validate_symbol(input)
  end
end

class FakeBoard
  attr_accessor :positions

  def initialize(positions)
    @positions = positions
  end

  def is_full
    @positions.count('-') == 0
  end

  def draw
    true
  end
end

class FakeValidation
  def initialize
    @called = false
  end

  def check_input_symbol(input = false)
    @called = true
    input
  end

  def check_position_range(input = false)
    @called = true
    input
  end

  def is_called
    @called
  end

  def check_board_position(input = false, _board = [])
    @called = true
    input
  end
end

class FakeMessages
  def out_of_range_message
    1
  end

  def invalid_input_message
    1
  end

  def position_taken_message
    1
  end

  def double_play_message
    1
  end
end
