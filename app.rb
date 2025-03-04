require "sinatra"
require "sinatra/reloader"

require "http"
require "json"
require "dotenv/load"

get("/") do
  @list_url = "https://api.exchangerate.host/list?access_key=" + ENV.fetch("FX_KEY")
  @raw_response = HTTP.get(@list_url)
  @string_response = @raw_response.to_s
  # parse to hash
  @parsed_response = JSON.parse(@string_response)
  
  @currencies = @parsed_response.fetch("currencies")

  erb(:homepage)
end


get("/:from_currency") do
  @list_url = "https://api.exchangerate.host/list?access_key=" + ENV.fetch("EXCHANGE_RATE_KEY")
  @raw_response = HTTP.get(@list_url)
  @string_response = @raw_response.to_s
  @parsed_response = JSON.parse(@string_response)
  @currencies = @parsed_response.fetch("currencies")

  @original_currency = params.fetch("from_currency")

  erb(:convert_a)
end


get("/:from_currency/:to_currency") do

  @original_currency = params.fetch("from_currency")
  @destination_currency = params.fetch("to_currency")

  @convert_url = "https://api.exchangerate.host/convert?from=#{@original_currency}&to=#{@destination_currency}&amount=1&access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}"
  @raw_response = HTTP.get(@convert_url)
  @string_response = @raw_response.to_s
  @parsed_response = JSON.parse(@string_response)
  @result = @parsed_response.fetch("result").to_s


  erb(:result)
end
