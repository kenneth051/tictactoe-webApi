require "sinatra"
require "json"
require "./lib/web_api/game"
require "./lib/web_api/io"
require "./lib/web_api/web_validation"

module WebApi
  class App < Sinatra::Base
    def initialize(app = nil, io = WebApi::Io.new,
                   messages = Tictactoe::Messages.new(Tictactoe::ALL_MESSAGES, io, 0),
                   validate = WebApi::WebValidation.new(Tictactoe::Validation.new, messages),
                   web_game = WebApi::Game.new(Tictactoe::Game.new(messages, io), io, validate))
      super(app)
      @io = io
      @messages = messages
      @validate = validate
      @web_game = web_game
    end

    post "/play" do
      body = JSON.parse(request.body.read)
      message = @web_game.play(body["symbol"], body["position"])
      if message.key?("error")
        return { "error" => message["error"] }.to_json
      end
      return { "success" => message }.to_json
    end
    get "/draw" do
      drawn_board = @web_game.draw()
      return { "board": drawn_board }.to_json
    end
    get "/reset_game" do
      message = @web_game.reset_game
      return { "message": message }.to_json
    end
  end
end
