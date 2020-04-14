# frozen_string_literal: true

require 'rack/test'
require 'sinatra'
require 'json'
require 'kenneth'

require './lib/web_api/app'
require './lib/web_api/game'

RSpec.describe WebApi::App do
  before(:each) do
    WebApi::Game.reset_board_moves
  end
  include Rack::Test::Methods

  let(:io) { WebApi::Io.new }
  let(:messages) { Tictactoe::Messages.new(Tictactoe::ALL_MESSAGES, io, 0) }
  let(:validate) { WebApi::WebValidation.new(Tictactoe::Validation.new, messages) }
  let(:web_game) { WebApi::Game.new(Tictactoe::Game.new(messages, io), io, validate) }

  def app
    WebApi::App.new(nil, io, messages, validate, web_game)
  end

  describe 'POST /play' do
    before do
      WebApi::Game.reset_board_moves
    end
    it 'updates the board and returns ok' do
      headers = { 'Content-Type' => 'application/json' }

      post '/play', { "symbol": 'x', "position": 3 }.to_json, headers
      expected_response = { "message": 'Ok' , "board": ['-', '-', 'x', '-', '-', '-', '-', '-', '-'] }

      expect(last_response.body).to eq(expected_response.to_json)
    end
    it 'returns error message if position is out of range' do
      headers = { 'Content-Type' => 'application/json' }
      post '/play', { "symbol": 'x', "position": 0 }.to_json, headers
      expect(last_response.body)
        .to eq({ "errors": ['message' => 'position out of range, enter from 1 to 9'] }.to_json)
    end
    it 'returns error message if symbol is invalid' do
      headers = { 'Content-Type' => 'application/json' }
      post '/play', { "symbol": 'e', "position": 8 }.to_json, headers
      expect(last_response.body)
        .to eq({ "errors": ['message' => "invalid input, symbol be either 'x' or 'o' lowercase"] }.to_json)
    end
    it 'returns error message if position has already been taken' do
      headers = { 'Content-Type' => 'application/json' }
      moves = [['o', 1], ['x', 5], ['o', 1]]
      moves.each do |move|
        post '/play', { "symbol": move[0], "position": move[1] }.to_json, headers
      end
      expect(last_response.body)
        .to eq({ "errors": [{ "message": 'position has been taken, choose another one' }] }.to_json)
    end
    it "signal a winner using 'o'" do
      headers = { 'Content-Type' => 'application/json' }
      moves = [['o', 1], ['x', 5], ['o', 3], ['x', 4], ['o', 2]]
      expected_response = { "message": "Player using 'o' has won!" , "board": ['o', 'o', 'o', 'x', 'x', '-', '-', '-', '-']}
      moves.each do |move|
        post '/play', { "symbol": move[0], "position": move[1] }.to_json, headers
      end
      expect(last_response.body)
        .to eq(expected_response.to_json)
    end
    it "signal a winner using 'x'" do
      headers = { 'Content-Type' => 'application/json' }
      moves = [['x', 1], ['o', 5], ['x', 3], ['o', 4], ['x', 2]]
      expected_response = { "message": "Player using 'x' has won!" , "board": ['x', 'x', 'x', 'o', 'o', '-', '-', '-', '-']}
      moves.each do |move|
        post '/play', { "symbol": move[0], "position": move[1] }.to_json, headers
      end
      expect(last_response.body)
        .to eq(expected_response.to_json)
    end
    it 'signal a draw' do
      headers = { 'Content-Type' => 'application/json' }
      moves = [
        ['o', 1], ['x', 2], ['o', 3], ['x', 5],
        ['o', 4], ['x', 7], ['o', 8], ['x', 9], ['o', 6],
      ]
      expected_response = { "message": " IT'S A DRAW!" , "board": ['o', 'x', 'o', 'o', 'x', 'o', 'x', 'o', 'x']}
      moves.each do |move|
        post '/play', { "symbol": move[0], "position": move[1] }.to_json, headers
      end
      expect(last_response.body).to eq(expected_response.to_json)
    end
  end

  describe 'GET /reset_game' do
    it 'return a success message after reseting the game' do
      headers = { 'Content-Type' => 'application/json' }
      moves = [['o', 1], ['x', 5], ['o', 3], ['x', 4], ['o', 2]]
      moves.each do |move|
        web_game.play(move[0], move[1])
      end
      expect(WebApi::Game.board_moves)
        .to eq([['o', 1], ['x', 5], ['o', 3], ['x', 4], ['o', 2]])
      expect(web_game.played_positions)
        .to eq(['o', 'o', 'o', 'x', 'x', '-', '-', '-', '-'])
      get '/reset_game', headers
      expected_response = { 'message' => 'Ok', "board": ['-', '-', '-', '-', '-', '-', '-', '-', '-'] }
      expect(last_response.body).to eq(expected_response.to_json)
      expect(WebApi::Game.board_moves).to eq([])
      expect(web_game.played_positions)
        .to eq(['-', '-', '-', '-', '-', '-', '-', '-', '-'])
    end
  end

  describe 'GET /draw' do
    WebApi::Game.reset_board_moves
    it 'return a board to the user' do
      headers = { 'Content-Type' => 'application/json' }
      get '/draw', headers
      expect(last_response.body).to eq(
        { "board": ['-', '-', '-', '-', '-', '-', '-', '-', '-'] }.to_json
      )
    end
  end
end
