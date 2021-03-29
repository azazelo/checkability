# Create connection
#
class ExternalApiCheckerConnector
  attr_reader :path
  
  def initialize(conf)
    @path = conf[:path]
  end
  
  def connect
    Faraday.new(:url => self.path) do |faraday|
      faraday.headers['Content-Type'] = 'application/json'
      faraday.adapter Faraday.default_adapter
    end
  end
end
