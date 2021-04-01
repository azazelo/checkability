require 'faraday'
require 'net/http'
require 'net/https'
require 'json'

module Checkability
  # Checks if postcode exists in external API
  #
  class ExternalApiChecker
    attr_reader :path, :path_suffix, :check_method, :connection, :http_verb,
                :failure_message, :success_message
                

    def initialize(conf = {})
      @path = conf[:path]
      @http_verb = conf[:http_verb] || :get
      @path_suffix = conf[:path_suffix] || ''
      @check_method = conf[:check_method]
      @failure_message = conf[:failure_message] || 'Failed.'
      @success_message = conf[:success_message] || 'Success.'
      @connection = Checkability::ExternalApiConnector.new(conf)
    end

    def check_value(checkable)
      @resp = connection.connect.send(http_verb, 
                                      checkable.value.delete(' ') + path_suffix)
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

      binding.pry
      return [true, _message(success_message)] if check_method.call(_parsed(@resp))

      [false, _message(failure_message)]
    rescue StandardError => e
      [false, _message(e)]
    end
  end
end
