module WebApi
  class WebValidation
    attr_accessor :errors

    def initialize(validate, messages)
      @validate = validate
      @messages = messages
      @errors = []
    end

    def get_errors
      @errors
    end

    def add_errors(error)
      @errors << error
    end

    def check_position_range(input)
      if !@validate.check_position_range(input)
        add_errors(@messages.out_of_range_message)
      end
    end

    def check_input_symbol(input)
      if !@validate.check_input_symbol(input)
        add_errors(@messages.invalid_input_message)
      end
    end

    def check_board_position(position, board)
      if !@validate.check_board_position(position, board)
        add_errors(@messages.position_taken_message)
      end
    end

    def check_consecutive_moves(symbol_list, symbol)
      if symbol_list[-1] == symbol
        add_errors(@messages.double_play_message)
        return true
      end
    end
  end
end
