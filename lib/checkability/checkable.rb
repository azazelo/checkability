module Checkability
  # Implements check method to Iterate on chechers
  # Possible to implemet as Iterator in future
  #
  class Checkable
    attr_reader :checkable

    def initialize(checkable)
      @checkable = checkable
    end

    # sentence is a proc
    #   like { |a,b,c| a && ( b || c ) }
    #   where a,b,c are checkers
    #   and each should return true|false
    # checkers is an array of checker objects
    #   e.g. [storage_checker, external_api_checker]
    def check(conf)
      conf[:strategy].call(
        conf[:checkers].map do |checker_name, checker_conf|
          _checker_to_check_value(checker_name, checker_conf)
        end
      )
    end

    private

    def _checker_to_check_value(checker_name, checker_conf)
      k = "Checkability::#{checker_name.to_s.camelize}".constantize
      k.new(checker_conf).check_value(checkable)
    rescue NameError => e
      checkable.messages << "#{e}: #{checker_name}."
      false
    end
  end
end
