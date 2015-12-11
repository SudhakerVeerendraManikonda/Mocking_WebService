
require 'csv'
require 'open-uri'

class NetAssetValue

	def calculate_net_asset_value(shares, price)
		shares * price 
	end

	def calculate_total_worth(worth_list)
		worth_list.inject(0, :+)
	end

	def retrieve_price_for_a_symbol(symbol)
		begin
			request_web_service(symbol)
		rescue Exception
			0
		end 
	end

	def request_web_service(symbol)
		begin
			(CSV.parse open("http://ichart.finance.yahoo.com/table.csv?s=#{symbol}").read, :headers=>true, :converters=>:numeric).first["Close"]
		rescue URI::InvalidURIError
			'Sorry, the page you requested was not found.'
		end
	end 

	def generate_report_for_worth(symbols_price_shares)
		result = Hash.new
		worth_list = Array.new

		symbols_price_shares.each do |symbol, value|
			key = symbol.to_s + '     ' + value[1].to_s + '     ' + value[0].to_s
			worth = calculate_net_asset_value(value[1].to_f, value[0].to_f)
			worth_list << worth
			result[key] = worth
		end
		
		worth_report= Hash[result.sort_by {|key,value| value}.reverse]
		return worth_report, calculate_total_worth(worth_list)
	end
end





