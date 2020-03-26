require_relative "../../lib/web_api/game"
require_relative "../../lib/web_api/io"
require_relative "../../lib/web_api/web_validation"
require_relative "../faker"
require "kenneth"

RSpec.describe WebApi::Game do
  context "reset_board_moves" do
    it "reset the #board_moves class variable" do
      io = WebApi::Io.new
      messages = Tictactoe::Messages.new(Tictactoe::ALL_MESSAGES, io, 0)
      game = Tictactoe::Game.new(messages, io)
      web_game = WebApi::Game.new(game, io = nil, validate = nil)
      web_game.update_moves(["o", 1])
      WebApi::Game.reset_board_moves
      expect(WebApi::Game.board_moves).to eq([])
    end
  end
  context "validate_position" do
    it "calls check_position_range function and check_board_position " do
      io = WebApi::Io.new
      messages = Tictactoe::Messages.new(Tictactoe::ALL_MESSAGES, io, 0)
      validate = WebApi::WebValidation.new(Tictactoe::Validation.new, messages)
      game = Tictactoe::Game.new(messages, io)
      web_game = WebApi::Game.new(game, io, validate)
      expect(validate).to receive(:check_position_range).with(1)
      expect(validate).to receive(:check_board_position).with(1, game.board.positions)
      web_game.validate_position(1)
    end
    it "return error message if input is invalid" do
      io = WebApi::Io.new
      messages = Tictactoe::Messages.new(Tictactoe::ALL_MESSAGES, io, 0)
      validate = WebApi::WebValidation.new(Tictactoe::Validation.new, messages)
      game = Tictactoe::Game.new(messages, io)
      web_game = WebApi::Game.new(game, io, validate)
      expect(web_game.validate_position(10)).to eq([{ :message => "position out of range, enter from 1 to 9" },
                                                    { :message => "position has been taken, choose another one" }])
    end
    it "return nil if input is valid" do
      io = WebApi::Io.new
      messages = Tictactoe::Messages.new(Tictactoe::ALL_MESSAGES, io, 0)
      validate = WebApi::WebValidation.new(Tictactoe::Validation.new, messages)
      game = Tictactoe::Game.new(messages, io)
      web_game = WebApi::Game.new(game, io, validate)
      expect(web_game.validate_position(1)).to eq(nil)
    end
  end
  context "validate_symbol" do
    it "calls check_input_symbol function" do
      io = WebApi::Io.new
      messages = Tictactoe::Messages.new(Tictactoe::ALL_MESSAGES, io, 0)
      validate = WebApi::WebValidation.new(Tictactoe::Validation.new, messages)
      game = Tictactoe::Game.new(messages, io)
      web_game = WebApi::Game.new(game, io, validate)
      expect(validate).to receive(:check_input_symbol).with("x")
      web_game.validate_symbol("x")
    end
    it "return an error if input is not 'x' or 'o'" do
      io = WebApi::Io.new
      messages = Tictactoe::Messages.new(Tictactoe::ALL_MESSAGES, io, 0)
      validate = WebApi::WebValidation.new(Tictactoe::Validation.new, messages)
      game = Tictactoe::Game.new(messages, io)
      web_game = WebApi::Game.new(game, io, validate)
      expect(web_game.validate_symbol("i")).to eq([{ :message => "invalid input, symbol be either 'x' or 'o' lowercase" }])
    end
    it "return nil if input is valid" do
      io = WebApi::Io.new
      messages = Tictactoe::Messages.new(Tictactoe::ALL_MESSAGES, io, 0)
      validate = WebApi::WebValidation.new(Tictactoe::Validation.new, messages)
      game = Tictactoe::Game.new(messages, io)
      web_game = WebApi::Game.new(game, io, validate)
      expect(web_game.validate_symbol("x")).to eq(nil)
    end
  end
  context "#board moves" do
    it "capture update #board_moves with new input" do
      game = FakeGame.new(FakeBoard.new([]))
      web_game = WebApi::Game.new(game, io = nil, validate = nil)
      WebApi::Game.reset_board_moves
      web_game.update_moves(["x", 1])
      expect(WebApi::Game.board_moves).to eq([["x", 1]])
    end
  end
  context "update_board" do
    it "should update the board with saved moves" do
      game = FakeGame.new(FakeBoard.new([]))
      web_game = WebApi::Game.new(game, io = nil, validate = nil)
      WebApi::Game.reset_board_moves
      web_game.update_moves(["o", 1])
      web_game.update_board
      expect(game.board.positions).to eq(["o"])
      web_game.update_moves(["x", 2])
      web_game.update_board
      expect(game.board.positions).to eq(["o", "x"])
    end
  end
  context "#play" do
    it "should call validate_symbol and validate_position methods" do
      io = WebApi::Io.new
      messages = Tictactoe::Messages.new(Tictactoe::ALL_MESSAGES, io, 0)
      validate = WebApi::WebValidation.new(Tictactoe::Validation.new, messages)
      game = Tictactoe::Game.new(messages, io)
      web_game = WebApi::Game.new(game, io = io, validate)
      expect(web_game).to receive(:validate_symbol).with("x")
      web_game.play("x", 1)
    end
    it "should call functions" do
      io = WebApi::Io.new
      messages = Tictactoe::Messages.new(Tictactoe::ALL_MESSAGES, io, 0)
      validate = WebApi::WebValidation.new(Tictactoe::Validation.new, messages)
      game = Tictactoe::Game.new(messages, io)
      web_game = WebApi::Game.new(game, io = io, validate)
      expect(web_game).to receive(:update_moves).with(["x", 1])
      expect(game).to receive(:make_move).with("x", 1)
      expect(game).to receive(:end?).with(no_args)
      web_game.play("x", 1)
    end
    it "ensure player using 'x' gets a winning message" do
      WebApi::Game.reset_board_moves
      io = WebApi::Io.new
      messages = Tictactoe::Messages.new(Tictactoe::ALL_MESSAGES, io, 0)
      validate = WebApi::WebValidation.new(Tictactoe::Validation.new, messages)
      game = Tictactoe::Game.new(messages, io, board = FakeBoard.new(["-", "o", "o", "x", "x", "-", "o", "-", "-"]))
      web_game = WebApi::Game.new(game, io = io, validate)
      expect(web_game.play("x", 6)).to eq({ "message": "Player using 'x' has won!" })
    end
    it "ensure player using 'o' gets a winning message" do
      WebApi::Game.reset_board_moves
      io = WebApi::Io.new
      messages = Tictactoe::Messages.new(Tictactoe::ALL_MESSAGES, io, 0)
      validate = WebApi::WebValidation.new(Tictactoe::Validation.new, messages)
      game = Tictactoe::Game.new(messages, io, board = FakeBoard.new(["-", "x", "x", "o", "o", "-", "x", "-", "-"]))
      web_game = WebApi::Game.new(game, io = io, validate)
      expect(web_game.play("o", 6)).to eq({ "message": "Player using 'o' has won!" })
    end
    it "return a draw message incase we have a tie" do
        WebApi::Game.reset_board_moves
        io = WebApi::Io.new
        messages = Tictactoe::Messages.new(Tictactoe::ALL_MESSAGES, io, 0)
        validate = WebApi::WebValidation.new(Tictactoe::Validation.new, messages)
        game = Tictactoe::Game.new(messages, io, board = FakeBoard.new(["o", "x", "o", "o", "x", "o", "x", "o", "-"]))
        web_game = WebApi::Game.new(game,io = io, validate)
        expect(web_game.play("x", 9)).to eq({ "message": " IT'S A DRAW!" })
      end
  end
  context "#draw" do
    it "return a drawn board to the user" do
      io = WebApi::Io.new
      messages = Tictactoe::Messages.new(Tictactoe::ALL_MESSAGES, io, 0)
      validate = WebApi::WebValidation.new(Tictactoe::Validation.new, messages)
      game = Tictactoe::Game.new(messages, io)
      web_game = WebApi::Game.new(game,io, validate)
      expect(web_game.draw).to eq(
        ["-", "-", "-", "-", "-", "-", "-", "-", "-"],
      )
    end
  end
  context "#prevent_consecutive_moves" do
    it "should ensure a player doesn't make consecutive moves" do
      WebApi::Game.reset_board_moves
      io = WebApi::Io.new
      messages = Tictactoe::Messages.new(Tictactoe::ALL_MESSAGES, io, 0)
      validate = WebApi::WebValidation.new(Tictactoe::Validation.new, messages)
      game = Tictactoe::Game.new(messages, io)
      web_game = WebApi::Game.new(game, io, validate)
      web_game.track_played_symbols("x")
      expect(game.symbols).to eq(["x"])
      web_game.track_played_symbols("o")
      expect(game.symbols).to eq(["x", "o"])
      web_game.track_played_symbols("o")
      expect(validate.get_errors).to eq([{ :message => "You cannot play consecutively" }])
      expect(game.symbols).to eq(["x", "o"])
    end
  end
end
