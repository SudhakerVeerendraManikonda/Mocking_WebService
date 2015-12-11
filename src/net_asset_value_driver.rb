$:.unshift(File.join(File.dirname(__FILE__), '..', 'src'))
$:.unshift '..'

require 'net_asset_value'

  asset = NetAssetValue.new
  symbols_shares_price = Hash.new 
  
  Hash[*open('symbols.txt').read.split(' ').flatten].each { |key, value|
    symbols_shares_price[key] = [asset.retrieve_price_for_a_symbol(key).to_s, value]
  }

  symbols_shares_price, total_worth = asset.generate_report_for_worth(symbols_shares_price)

  printf "\n%-30s %s" , "Symbol  Shares    Price" , "Worth"
  symbols_shares_price.each {|key, value| printf "\n%-30s %s " , key , value } 
  printf "\n\n %-10s %s", "Total Worth:" , total_worth
