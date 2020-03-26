require "json"
require "kenneth"

module WebApi
  class Game
    @@board_moves = []

    def initialize(game, io, validate)
      @game = game
      @validate = validate
      @io = io
    end

    def validate_position(position, board = @game.board.positions)
      @validate.check_position_range(position)
      @validate.check_board_position(position, board)
    end

    def self.board_moves
      @@board_moves
    end

    def self.reset_board_moves
      @@board_moves = []
    end

    def validate_symbol(symbol)
      @validate.check_input_symbol(symbol)
    end

    def update_moves(input)
      @@board_moves << input
    end

    def track_played_symbols(symbol)
      if !@validate.check_consecutive_moves(@game.symbols, symbol)
        @game.symbols << symbol
      end
    end

    def update_board
      Game.board_moves.each do |moves|
        @game.board.positions[moves[1] - 1] = moves[0]
      end
    end

    def draw
      @game.board.positions
    end

    def game_status
      return @game.draw? if @game.draw?
      @game.win?
    end

    def play(symbol, position)
      @validate.errors = []
      validate_position(position)
      validate_symbol(symbol)
      return { "error" => @validate.get_errors } if @validate.get_errors.any?
      update_moves([symbol, position])
      @game.make_move(symbol, position)
      update_board
      if @game.end?
        return game_status
      end
      { "message" => "Ok" }
    end
  end
end
