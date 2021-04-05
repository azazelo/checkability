# frozen_string_literal: true

module Checkability
  # Checks if postcode comply with regex
  #
  class Validator < BaseChecker
    attr_reader :format

    def post_initialize(conf = {})
      @format = conf[:format]
    end

    def result(checkable)
      !(checkable.value.delete(' ') =~ format[:regex]).nil?
    end
  end
end
