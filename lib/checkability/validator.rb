# frozen_string_literal: true

module Checkability
  # Checks if postcode comply with regex
  #
  class Validator < AbstractChecker
    attr_reader :format

    def post_initialize(conf = {})
      @format = conf[:format]
    end

    def result_and_message(checkable)
      position = checkable.value.delete(' ') =~ format[:regex]
      result = !position.nil?
      if result
        [result, message("Value is COMPLY with format of #{format[:name]}.", result)]
      else
        [result, message("Value is NOT COMPLY with format of #{format[:name]}.", result)]
      end
    end
    
  end
end
