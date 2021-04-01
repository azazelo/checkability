# frozen_string_literal: true

module Checkability
  # Implements check method to Iterate on chechers
  # Possible to implemet as Iterator in future
  #
  class Checkable
    attr_reader :checkable

    def initialize(checkable)
      @checkable = checkable
    end

    # strategy is a proc
    #   like { |a,b,c| a && ( b || c ) }
    #   where a,b,c are checkers
    #   and each should return true|false
    # checker_confs is an array of checker_conf hashes
    #   e.g. [storage_checker, external_api_checker]
    def check(opts = {})
      results = []
      opts[:checker_confs].each do |checker_conf|
        results << (res = _checker_to_check_value(checker_conf))
        break if res && checker_conf[:stop_process_if_success]
        break if res == false && checker_conf[:stop_process_if_failure]
      end
      opts[:strategy].call(results)
    end

    private

    def _checker_to_check_value(checker_conf)
      k = "Checkability::#{checker_conf[:name].to_s.camelize}".constantize
      k.new(checker_conf).check_value(checkable)
    rescue NameError => e
      checkable.messages << "false::#{e}: #{checker_conf[:name]}."
      false
    end
  end
end
