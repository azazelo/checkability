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
    def check(opts = {})
      results = []
      opts[:checkers].each do |checker|
        results << (res = _checker_to_check_value(checker))
        break if res && checker[:stop_process_if_success]
        break if res == false && checker[:stop_process_if_failure]
      end
      opts[:strategy].call(results)
    end

    private

    def _checker_to_check_value(checker)
      k = "Checkability::#{checker[:name].to_s.camelize}".constantize
      k.new(checker).check_value(checkable)
    rescue NameError => e
      checkable.messages << "#{e}: #{checker[:name]}."
      false
    end
  end
end
