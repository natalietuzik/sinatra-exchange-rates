require "sinatra"
require "sinatra/reloader"
require "http"
require "dotenv"

Dotenv.load

def call_api()
  # EXCHANGE LIST
  @exchange_api = ENV.fetch("EXCHANGE_RATE_KEY")
  currencies = HTTP.get("https://api.exchangerate.host/list?access_key=#{@exchange_api}")
  currencies_parsed = currencies.parse
  currencies_hash = currencies_parsed["currencies"]
  @currencies_array = currencies_hash.keys
end

# before do
#   @currencies_array = currencies_hash.keys
# end

get("/") do
  call_api()
  erb(:index)
end

get("/:currency_from") do
  # @currencies_list = currencies_parsed['currecnies']
  call_api()
  @currency_from = params.fetch("currency_from")
  erb(:currency)
end

get("/:currency_from/:currency_to") do
  call_api()
  @currency_from = params.fetch("currency_from")
  @currency_to = params.fetch("currency_to")
  # EXCHANGE CONVERT
  currency_convert = HTTP.get("https://api.exchangerate.host/convert?from=#{@currency_from}&to=#{@currency_to}&amount=1&access_key=#{@exchange_api}")
  currency_convert_hash = currency_convert.parse
  @currency_convert_result = currency_convert_hash["result"].to_s
  erb(:currency_converted)
end
