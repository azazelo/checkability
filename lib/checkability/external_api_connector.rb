# frozen_string_literal: true

require 'faraday'

module Checkability
  # Create connection
  #
  class ExternalApiConnector
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def connection
      Faraday.new(url: path) do |faraday|
        faraday.headers['Content-Type'] = 'application/json'
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
