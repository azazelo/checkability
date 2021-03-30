# Checks if postcode exists in Storage
#
module Checkability
  class Checkable
    attr_reader :checkable

    def initialize(checkable)
      @checkable = checkable
    end

    # sentence is a proc 
    #   like { |a,b,c| a && ( b || c ) } 
    #   where a,b,c are checkers 
    #   and each should return [true, message] or [false, message]
    # checkers is an array of checker objects
    #   e.g. [storage_checker, external_api_checker]
    def check(conf)
      conf[:algoritm].call( 
        conf[:checkers].map do |checker_name, checker_conf|
          k = Checkability.const_get(checker_name.to_s.camelize)
          k.new(checker_conf).check_value(checkable)
        end
      )
    end
  end
end