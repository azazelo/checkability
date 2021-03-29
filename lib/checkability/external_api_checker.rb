#require 'faraday_middleware'
require 'faraday'
require 'net/http'
require 'net/https'
require 'json'

# Checks if postcode exists in Storage
#
class ExternalApiChecker
  attr_reader :path, :check_method, :connection
  
  def initialize(conf)
    @path = conf[:path]
    @check_method = conf[:check_method]
    @connection = ExternalApiCheckerConnector.new(conf).connect
  end
  
  def check_value(checkable)
    @resp = connection.get(checkable.value.gsub(' ',''))
    checkable.results << _result
  end

  private

  def _message(str); "#{path}: #{str}";     end
  
  def _parsed(resp); JSON.parse(resp.body); end
  
  def _result
    return [false, _message(@resp.status)] unless @resp.status == 200
    
    return [true, _message('Found.')] if check_method.call(_parsed(@resp))
    
    [false, _message('Not found in allowed areas.')]
  rescue Exception => e
    [false, _message(e)]
  end
end
