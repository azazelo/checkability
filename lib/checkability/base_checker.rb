# frozen_string_literal: true

require_relative 'checker'

module Checkability
  # @abstract
  class BaseChecker < Checker
    # @return [Handler]
    attr_reader :stop_process_on_success, :stop_process_on_failure,
                :success_message, :failure_message

    def initialize(opts = {})
      @stop_process_on_failure = opts.fetch(:stop_process_on_failure) || false
      @stop_process_on_success = opts.fetch(:stop_process_on_success) || false
      @success_message = opts.fetc(:success_message) || 'Success.'
      @failure_message = opts.fetc(:failure_message) || 'Failed.'

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
      @next_handler = handler

      handler
    end

    # @abstract
    #
    # @param [String] request
    #
    # @return [Boolean, nil]
    def handle(check_obj)
      res, mess = result_and_message(check_obj)
      check_obj.ch_messages << mess
      check_obj.ch_allowed = res

      return if _stop_here?(res)

      @next_handler&.handle(check_obj) if @next_handler
    end

    def result_and_message(check_obj = nil)
      res = result(check_obj)

      str = res ? success_message : failure_message
      [res, message(res, str)]
    rescue StandardError => e
      [false, message(false, e)]
    end

    # subclass should implement
    def result(_check_obj)
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    # subclass may override
    def message(res, str)
      "#{res}:::#{str}"
    end

    private

    def _stop_here?(res)
      (res && stop_process_on_success) || (!res && stop_process_on_failure)
    end
  end
end
