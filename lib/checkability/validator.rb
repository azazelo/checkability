# frozen_string_literal: true

module Checkability
  # Checks if postcode comply with regex
  #
  class Validator < AbstractChecker
    attr_reader :format

    def post_initialize(conf = {})
      @format = conf[:format]
    end

    private

    def _result(checkable)
      !(checkable.value.delete(' ') =~ format[:regex]).nil?
    end
  end
end
