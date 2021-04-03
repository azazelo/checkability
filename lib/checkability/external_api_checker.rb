# frozen_string_literal: true

require 'faraday'
require 'net/http'
require 'net/https'
require 'json'

# frozen_string_literal: true

require_relative 'chain_of_resp/abstract_handler'
module Checkability
  # Checks if postcode exists in external API
  #
  class ExternalApiChecker < ChainOfResp::AbstractHandler
    attr_reader :path, :path_suffix, :check_method, :connection, :http_verb,
                :failure_message, :success_message

    def post_initialize(conf = {})
      @path = conf[:path]
      @http_verb = conf[:http_verb] || :get
      @path_suffix = conf[:path_suffix] || ''
      @check_method = conf[:check_method]
      @failure_message = conf[:failure_message] || 'Failed.'
      @success_message = conf[:success_message] || 'Success.'
      @connection = Checkability::ExternalApiConnector.new(conf)
    end

    def check_value(checkable)
      @resp = connection
              .connect
              .send(http_verb, "#{checkable.value.delete(' ')}#{path_suffix}")
      result, message = _result_and_message
      checkable.messages << message
      result
    end

    private

    def _message(str, res)
      "#{res}::#{path}: #{str}"
    end

    def _parsed(resp)
      JSON.parse(resp.body)
    end

    def _result_and_message
      return [false, _message(@resp.status, false)] unless @resp.status == 200

      return [true, _message(success_message, true)] if check_method
                                                        .call(_parsed(@resp))

      [false, _message(failure_message, false)]
    rescue StandardError => e
      [false, _message(e, false)]
    end
  end
end
