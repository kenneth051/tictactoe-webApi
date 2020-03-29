# frozen_string_literal: true

module WebApi
  class Io
    def output(message)
      { "message": message }
    end
  end
end
