class FakeGame
  attr_accessor :board

  def initialize(board)
    @board = board
  end
end

class WebApiGame
  def initialize(game, io = nil, validate = nil)
  end

  def validate_symbol(input)
    @validate_symbol = true
  end

  def validate_symbol_is_called
    return @validate_symbol
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
    @positions.count("-") == 0
  end

  def draw
    return true
  end
end

class FakeValidation
  def initialize
    @called = false
  end


  def check_input_symbol(input = false)
    @called = true
    return input
  end

  def check_position_range(input = false)
    @called = true
    return input
  end

  def is_called
    return @called
  end

  def check_board_position(input = false, board = [])
    @called = true
    return input
  end
end

class FakeMessages
  def out_of_range_message()
    return 1
  end

  def invalid_input_message()
    return 1
  end

  def position_taken_message()
    return 1
  end
  def double_play_message()
    return 1
  end
end
