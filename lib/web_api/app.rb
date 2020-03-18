require "sinatra"

module WebApi
  class App < Sinatra::Base
    get "/"do
      "Hello world"
    end
  end
end