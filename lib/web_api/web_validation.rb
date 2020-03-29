# frozen_string_literal: true

module WebApi
  class WebValidation
    def initialize(validate, messages)
      @validate = validate
      @messages = messages
      @errors = []
    end

    def errors
      { "errors": @errors }
    end

    def clear_errors
      @errors = []
    end

    def add_errors(error)
      @errors << error
    end

    def check_position_range(input)
      return if @validate.check_position_range(input)

      add_errors(@messages.out_of_range_message)
    end

    def check_input_symbol(input)
      add_errors(@messages.invalid_input_message) unless @validate.check_input_symbol(input)
    end

    def check_board_position(position, board)
      add_errors(@messages.position_taken_message) unless @validate.check_board_position(position, board)
    end

    def check_consecutive_moves(symbol_list, symbol)
      if symbol_list[-1] == symbol
        add_errors(@messages.double_play_message)
        true
      end
    end
  end
end
