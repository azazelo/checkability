# Checks if postcode exists in Storage
#
module Checkability
  class Validator
    attr_reader :format

    def initialize(conf={})
      @format = conf[:format]
    end

    def check_value(checkable)
      result, message = _result_and_message(checkable)
      checkable.messages << message
      result
    end
    
    def _result_and_message(checkable)
      if (checkable.value.gsub(' ','') =~ format[:regex]).nil?
        [false, "Value is not comply with format of #{format[:name]}."]
      else
        [true, "Value comply with format of #{format[:name]}."]
      end
    end
  end
end