$:.unshift(File.join(File.dirname(__FILE__), '..', 'src'))
$:.unshift '..'

require 'simplecov'
SimpleCov.start

require 'net_asset_value'
require 'test/unit'
require 'stringio'

class NetAssetValueTest  < Test::Unit::TestCase
    
    def setup
        @asset = NetAssetValue.new
    end
    
    def test_canary
        assert true
    end
    
    def test_calculate_net_asset_value_for_a_symbol
        assert_equal(100, @asset.calculate_net_asset_value(20, 5))
    end
    
    def test_calculate_net_asset_value_for_zero_shares
        assert_equal(0, @asset.calculate_net_asset_value(0, 40))
    end
    
    def test_calculate_net_asset_value_with_price_zero
        assert_equal(0, @asset.calculate_net_asset_value(20, 0))
    end
    
    def test_calculate_total_worth
        assert_equal(15, @asset.calculate_total_worth([1, 2, 3, 4, 5]))
    end
    
    def test_calculate_total_worth_with_empty_worth_list
        assert_equal(0, @asset.calculate_total_worth([]))
    end

    def test_retrieve_price_for_symbol_GOOG
        @asset.send(:define_singleton_method, :request_web_service) { |symbol| 99.99 }
        assert_equal(99.99, @asset.retrieve_price_for_a_symbol('GOOG'))
    end

    def test_retrieve_price_for_symbol_YHOO
        @asset.send(:define_singleton_method, :request_web_service) { |symbol| 34.50 }
        assert_equal(34.50, @asset.retrieve_price_for_a_symbol('YHOO'))
    end

    def test_retrieve_price_for_invalid_symbol
        @asset.send(:define_singleton_method, :request_web_service) { |symbol| 0 }
        assert_equal(0, @asset.retrieve_price_for_a_symbol('abc'))
    end

    def test_retrieve_price_when_web_service_throws_RuntimeError
        @asset.send(:define_singleton_method, :request_web_service) { |symbol| raise RuntimeError }
        assert_equal(0, @asset.retrieve_price_for_a_symbol('YHOO'))
    end

    def test_retrieve_price_when_web_service_throws_TimeOutError
        @asset.send(:define_singleton_method, :request_web_service) { |symbol| raise TimeoutError }
        assert_equal(0, @asset.retrieve_price_for_a_symbol('YHOO'))
    end

    def test_retrieve_price_when_web_service_throws_OtherErrors
        @asset.send(:define_singleton_method, :request_web_service) { |symbol| Error }
        assert_equal(0, @asset.retrieve_price_for_a_symbol('YHOO'))
    end

    def test_generate_report_for_worth
        symbols_price_shares = {:GOOG => ["35.5","100"], :YHOO => ["99.99", "50"]}
        expected_output = {"YHOO     50     99.99" => 4999.5, "GOOG     100     35.5" => 3550.0}, 8549.5
        
        assert_equal(expected_output, @asset.generate_report_for_worth(symbols_price_shares))
    end

    def test_get_a_response_from_webservice_for_YHOO
        symbol = 'YHOO'
        response = @asset.request_web_service(symbol)
        assert(response > 0)
    end

    def test_get_a_response_from_webservice_for_invalid_symbol
        symbol = '*&^%'
        assert_equal('Sorry, the page you requested was not found.', @asset.request_web_service(symbol))
    end
end 