# frozen_string_literal: true

require_relative 'checker'

module Checkability
  # @abstract
  class AbstractChecker < Checker
    # @return [Handler]
    attr_accessor :handler
    attr_reader :stop_process_on_success, :stop_process_on_failure, 
                :success_message, :failure_message

    def initialize(opts = {})
      @stop_process_on_failure = opts[:stop_process_on_failure] || false
      @stop_process_on_success = opts[:stop_process_on_success] || false
      @success_message = opts[:success_message] || 'Success.'
      @failure_message = opts[:failure_message] || 'Failed.'

      @next_handler = nil
      post_initialize(opts) # implemented in subclass
    end
    
    # subclass should implement
    def post_initialize(_opts)
      nil
    end

    # @param [Handler] handler
    #
    # @return [Handler]
    def next_handler(handler)
      @handler = handler if handler

      handler
    end

    # @abstract
    #
    # @param [String] request
    #
    # @return [Boolean, nil]
    def handle(checkable)
      res, mess = result_and_message(checkable)
      checkable.ch_messages << mess

      return true  if res && stop_process_on_success

      return false if !res && stop_process_on_failure

      handler&.handle(checkable)
    end

    def result_and_message(checkable=nil)
      return [false, 'No checkable object given'] unless checkable
      
      res = result(checkable)
      
      str = res ? success_message : failure_message
      [res, message(res, str)]
    rescue StandardError => e
      [false, message(false, e)]
    end

    # subclass should implement
    def result(_checkable)
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    # subclass may override
    def message(res, str)
      "#{res}::#{str}"
    end
  end
end
