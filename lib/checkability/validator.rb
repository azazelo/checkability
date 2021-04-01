module Checkability
  # Checks if postcode comply with regex
  #
  class Validator
    attr_reader :format

    def initialize(conf = {})
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
        [false, "Value is NOT COMPLY with format of #{format[:name]}."]
      else
        [true, "Value is COMPLY with format of #{format[:name]}."]
      end
    end
  end
end
