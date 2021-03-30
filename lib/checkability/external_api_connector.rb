module Checkability
  # Create connection
  #
  class ExternalApiConnector
    attr_reader :path

    def initialize(conf)
      @path = conf[:path]
    end

    def connect
      Faraday.new(url: path) do |faraday|
        faraday.headers['Content-Type'] = 'application/json'
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
