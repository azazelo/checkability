# frozen_string_literal: true

require 'forwardable'

module Checkability
  # Checks if postcode exists in external API
  #
  class ExternalApiChecker < BaseChecker
    attr_reader :path, :path_suffix, :check_method, :connector, :http_verb

    extend Forwardable
    def_delegators :@connector, :connection

    def post_initialize(conf = {})
      @path = conf[:path]
      @http_verb = conf[:http_verb] || :get
      @path_suffix = conf[:path_suffix] || ''
      @check_method = conf[:check_method]
      @connector = conf[:connector] ||
                   Checkability::ExternalApiConnector.new(conf[:path])
      @resp = nil
    end

    def result(check_obj)
      return false unless resp(check_obj).status == 200

      check_method.call(_parsed(resp(check_obj)))
    end

    def resp(check_obj)
      @resp ||= connection
                .send(http_verb,
                      "#{check_obj.value.delete(' ')}#{path_suffix}")
      # .get('SE17QD')
    end

    def message(res, str = nil)
      "#{res}::#{path}: #{str}"
    end

    private

    def _parsed(resp)
      JSON.parse(resp.body)
    end
  end
end
