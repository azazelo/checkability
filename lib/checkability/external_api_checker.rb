# frozen_string_literal: true

require 'faraday'
require 'net/http'
require 'net/https'
require 'json'

# frozen_string_literal: true

module Checkability
  # Checks if postcode exists in external API
  #
  class ExternalApiChecker < AbstractChecker
    attr_reader :path, :path_suffix, :check_method, :connection, :http_verb

    def post_initialize(conf = {})
      @path = conf[:path]
      @http_verb = conf[:http_verb] || :get
      @path_suffix = conf[:path_suffix] || ''
      @check_method = conf[:check_method]
      @connection = Checkability::ExternalApiConnector.new(conf)
    end

    def result(checkable)
      resp = connection
             .connect
             .send(http_verb, "#{checkable.value.delete(' ')}#{path_suffix}")
      return false unless resp.status == 200

      check_method.call(_parsed(resp))
    end

    def message(res, str)
      "#{res}::#{path}: #{str}"
    end
    
    private

    def _parsed(resp)
      JSON.parse(resp.body)
    end
  end
end
