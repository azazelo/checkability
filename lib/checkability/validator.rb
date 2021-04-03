# frozen_string_literal: true

module Checkability
  # Checks if postcode comply with regex
  #
  class Validator < ChainOfResp::AbstractHandler
    attr_reader :format

    def post_initialize(conf = {})
      @format = conf[:format]
    end

    def check_value(checkable)
      result, message = _result_and_message(checkable)
      checkable.messages << message
      result
    end

    private

    def _result_and_message(checkable)
      if (checkable.value.delete(' ') =~ format[:regex]).nil?
        [false, "false::Value is NOT COMPLY with format of #{format[:name]}."]
      else
        [true, "true::Value is COMPLY with format of #{format[:name]}."]
      end
    end
  end
end
