require "./lib/web_api/io"

RSpec.describe WebApi do
  context "#output" do
    it "should return output in json format" do
      io = WebApi::Io.new
      expect(io.output("welcome")).to eq({ "message": "welcome" })
    end
  end
end
