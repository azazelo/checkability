# frozen_string_literal: true

module Checkability
  # @abstract
  class Checker
    # @abstract
    #
    # @param [Handler] handler
    def next_handler=(_handler)
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    # @abstract
    #
    # @param [String] request
    #
    # @return [String, nil]
    def handle(_handler)
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    # @abstract
    #
    # @param [String] request
    #
    # @return Array [ [Boolean, true|false], String, message] ]
    def result_and_message(_object)
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    # @abstract
    #
    # @param [Checkable object] request
    #
    # @return [Boolean, true|false]
    def result(_object)
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    # @abstract
    #
    # @params [Boolean], [String]
    #
    # @return [String]
    def message(_res, _str)
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end
  end
end
