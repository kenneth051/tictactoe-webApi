# frozen_string_literal: true

require 'sinatra'
require 'sinatra/cross_origin'
require 'json'
require './lib/web_api/game'
require './lib/web_api/io'
require './lib/web_api/web_validation'

module WebApi
  class App < Sinatra::Base
    def initialize(app = nil, io = WebApi::Io.new,
                   messages = Tictactoe::Messages.new(
                     Tictactoe::ALL_MESSAGES, io, 0
                   ),
                   validate = WebApi::WebValidation.new(
                     Tictactoe::Validation.new, messages
                   ),
                   web_game = WebApi::Game.new(
                     Tictactoe::Game.new(messages, io), io, validate
                   ))
      super(app)
      @io = io
      @messages = messages
      @validate = validate
      @web_game = web_game
    end

    configure do
      enable :cross_origin
    end

    before do
      response.headers['Access-Control-Allow-Origin'] = '*'
    end

    post '/play' do
      body = JSON.parse(request.body.read)
      message = @web_game.play(body['symbol'], body['position'])
      return message.to_json
    end
    get '/draw' do
      message = @web_game.draw
      return message.to_json
    end
    get '/reset_game' do
      message = @web_game.reset_game
      return message.to_json
    end
    options "*" do
      response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
      response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
      response.headers["Access-Control-Allow-Origin"] = "*"
      200
    end
  end
end
