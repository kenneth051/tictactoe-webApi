require "sinatra"
module WebApi 
  class SinatraApp < Sinatra::Base
  get "/"do
    "Hello world"
  end
end
end
