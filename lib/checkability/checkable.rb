# frozen_string_literal: true

require 'forwardable'

module Checkability
  # Implements check method to Iterate on chechers
  # Possible to implemet as Iterator in future
  #
  class Checkable
    attr_accessor :check_obj

    extend Forwardable
    def_delegators :@check_obj, :ch_messages, :ch_allowed

    def initialize(check_obj)
      @check_obj = check_obj
    end

    # As in result handlers should behave like this:
    # validator    .next_handler(storage)
    # storage      .next_handler(api_validator)
    # api_validator.next_handler(api_finder)
    # api_validator.next_handler(nil)
    #
    # validator.handle(request)
    #
    # ChainOfResponsibilty
    #
    def check(handler_confs)
      first_handler_name = handler_confs.keys.first
      first_handler = _handlers(handler_confs)[first_handler_name]

      first_handler.handle(check_obj)
    rescue StandardError => e
      check_obj.ch_messages << "false::#{e}: #{handler_confs}."
      false
    end

    private

    def _handlers(handler_confs)
      handlers = _make_handlers(handler_confs)
      handlers.each_value.with_index do |handler, i|
        next_handler_name = handlers.keys[i + 1]
        handler.next_handler(handlers[next_handler_name]) if handlers[next_handler_name]
      end
      handlers
    end

    def _make_handlers(confs)
      confs.transform_values { |conf| _make_handler(conf) }
    end

    def _make_handler(conf)
      Checkability.const_get(conf[:name].to_s.camelize)
                  .new(conf)
    end
  end
end
