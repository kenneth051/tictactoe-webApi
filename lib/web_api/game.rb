# frozen_string_literal: true

require 'json'
require 'kenneth'

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
      @game.symbols << symbol unless @validate.check_consecutive_moves(@game.symbols, symbol)
    end

    def update_board
      Game.board_moves.each do |moves|
        @game.board.positions[moves[1] - 1] = moves[0]
      end
    end

    def played_positions
      @game.played_positions
    end

    def reset_game
      Game.reset_board_moves
      @game.prepare_new_game
      { 'message' => 'Ok', "board" => @game.board.positions }
    end

    def draw
      { "board": @game.board.positions }
    end

    def message_from_game
      return game_status if @game.end?

      { 'message' => 'Ok' }
    end

    def game_status
      @game.win? || @game.draw?
    end

    def play(symbol, position)
      unless @game.end?
        @validate.clear_errors
        validate_position(position)
        validate_symbol(symbol)
        track_played_symbols(symbol)
        message = @validate.errors
        if message[:errors].none?
          update_moves([symbol, position])
          @game.make_move(symbol, position)
          update_board
          message = message_from_game.merge(draw)
        end
      end
      message || game_status
    end
  end
end
