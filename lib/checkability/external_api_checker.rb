require 'faraday'
require 'net/http'
require 'net/https'
require 'json'

module Checkability
  # Checks if postcode exists in external API
  #
  class ExternalApiChecker
    attr_reader :path, :check_method, :connection

    def initialize(conf = {})
      @path = conf[:path]
      @check_method = conf[:check_method]
      @connection = Checkability::ExternalApiConnector.new(conf)
    end

    def check_value(checkable)
      @resp = connection.connect.get(checkable.value.delete(' '))
      result, message = _result_and_message
      checkable.messages << message
      result
    end

    private

    def _message(str)
      "#{path}: #{str}"
    end

    def _parsed(resp)
      JSON.parse(resp.body)
    end

    def _result_and_message
      return [false, _message(@resp.status)] unless @resp.status == 200

      return [true, _message('Found.')] if check_method.call(_parsed(@resp))

      [false, _message('Not found in allowed areas.')]
    rescue StandardError => e
      [false, _message(e)]
    end
  end
end
