# frozen_string_literal: true

require_relative '../../lib/web_api/web_validation'
require_relative '../faker'

RSpec.describe WebApi::WebValidation do
  context '#errors' do
    it 'get errors if we have any' do
      fake_validation = FakeValidation.new
      fake_messages = FakeMessages.new
      validate = WebApi::WebValidation.new(fake_validation, fake_messages)
      expect(validate.errors).to eq({ "errors": [] })
    end
  end
  context '#add_errors' do
    it 'add errors if we have any' do
      fake_validation = FakeValidation.new
      fake_messages = FakeMessages.new
      validate = WebApi::WebValidation.new(fake_validation, fake_messages)
      validate.add_errors('error')
      expect(validate.errors).to eq({ "errors": ['error'] })
    end
  end
  context '#clear_errors' do
    it 'clears existing errors' do
      fake_validation = FakeValidation.new
      fake_messages = FakeMessages.new
      validate = WebApi::WebValidation.new(fake_validation, fake_messages)
      validate.add_errors('error')
      expect(validate.errors).to eq({ "errors": ['error'] })
      validate.clear_errors
      expect(validate.errors).to eq({ "errors": [] })
    end
  end
  context '#check_position_range' do
    it 'there should be no errors if position is within range' do
      fake_validation = FakeValidation.new
      fake_messages = FakeMessages.new
      validate = WebApi::WebValidation.new(fake_validation, fake_messages)
      expect(validate.check_position_range(true)).to eq(nil)
    end
    it 'there should be errors if position is out of range' do
      fake_validation = FakeValidation.new
      fake_messages = FakeMessages.new
      validate = WebApi::WebValidation.new(fake_validation, fake_messages)
      expect(validate.check_position_range(false)).to eq([1])
    end
    it 'calls add_errors,check_position_range from validate base class' do
      fake_validation = FakeValidation.new
      fake_messages = FakeMessages.new
      validate = WebApi::WebValidation.new(fake_validation, fake_messages)
      expect(validate).to receive(:add_errors).with(1).and_return([1])
      validate.check_position_range(false)
      expect(fake_validation.is_called).to eq(true)
    end
  end
  context 'check_input_symbol' do
    it 'there should be no errors if symbol is valid' do
      fake_validation = FakeValidation.new
      fake_messages = FakeMessages.new
      validate = WebApi::WebValidation.new(fake_validation, fake_messages)
      expect(validate.check_input_symbol(true)).to eq(nil)
    end
    it 'there should be errors if symbol is valid' do
      fake_validation = FakeValidation.new
      fake_messages = FakeMessages.new
      validate = WebApi::WebValidation.new(fake_validation, fake_messages)
      expect(validate.check_input_symbol(false)).to eq([1])
    end
    it 'calls add_errors,check_input_symbol from validate base class' do
      fake_validation = FakeValidation.new
      fake_messages = FakeMessages.new
      validate = WebApi::WebValidation.new(fake_validation, fake_messages)
      expect(validate).to receive(:add_errors).with(1).and_return([1])
      validate.check_input_symbol(false)
      expect(fake_validation.is_called).to eq(true)
    end
  end
  context 'check_board_position' do
    it 'there should be no errors if position on board is not taken' do
      fake_validation = FakeValidation.new
      fake_messages = FakeMessages.new
      validate = WebApi::WebValidation.new(fake_validation, fake_messages)
      expect(validate.check_board_position(true, [])).to eq(nil)
    end
    it 'there should be errors if position on board is taken' do
      fake_validation = FakeValidation.new
      fake_messages = FakeMessages.new
      validate = WebApi::WebValidation.new(fake_validation, fake_messages)
      expect(validate.check_board_position(false, [])).to eq([1])
    end
    it 'calls add_errors,check_board_position from validate base class' do
      fake_validation = FakeValidation.new
      fake_messages = FakeMessages.new
      validate = WebApi::WebValidation.new(fake_validation, fake_messages)
      expect(validate).to receive(:add_errors).with(1).and_return([1])
      validate.check_board_position(false, [])
      expect(fake_validation.is_called).to eq(true)
    end
  end
  context '#check_consecutive_moves' do
    it 'return true if a player plays consecutively' do
      fake_validation = FakeValidation.new
      fake_messages = FakeMessages.new
      validate = WebApi::WebValidation.new(fake_validation, fake_messages)
      expect(validate.check_consecutive_moves(['x'], 'x')).to eq(true)
    end
    it "return nil if a player doesn't play consecutively" do
      fake_validation = FakeValidation.new
      fake_messages = FakeMessages.new
      validate = WebApi::WebValidation.new(fake_validation, fake_messages)
      validate.check_consecutive_moves([], 'x')
      expect(validate.check_consecutive_moves([], 'x')).to eq(nil)
    end
    it 'call add_errors' do
      fake_messages = FakeMessages.new
      validate = WebApi::WebValidation.new(nil, fake_messages)
      expect(validate).to receive(:add_errors).with(1).and_return([1])
      validate.check_consecutive_moves(['x'], 'x')
    end
  end
end
