# frozen_string_literal: true

module Checkability
  # Implements check method to Iterate on chechers
  # Possible to implemet as Iterator in future
  #
  class Checkable
    attr_reader :checkable

    def initialize(checkable)
      @checkable = checkable
      @checkable.messages = []
    end

    # As in result handlers should behave like this:
    # validator    .set_next(storage)
    # storage      .set_next(api_validator)
    # api_validator.set_next(api_finder)
    # api_validator.set_next(nil)
    #
    # validator.handle(request)
    #
    def check(opts = {})
      require 'pry'; binding.pry
      first_handler_name = opts[:first_handler]
      _handlers(opts)[first_handler_name].handle(checkable)
    rescue StandardError => e
      checkable.messages << "false::#{e}: #{opts}."
      false
    end

    private

    def _handlers(opts)
      handler_confs = opts[:handler_confs]
      handlers = {}
      handler_confs.each do |handler_name, handler_conf|
        handlers[handler_name] = _make_handler(handler_name, handler_conf)
      end
      handlers.each do |handler_name, handler|
        next_handler_name = handler_confs[handler_name][:next_handler]
        handler.next_handler(handlers[next_handler_name])
      end
    end

    def _make_handler(_name, conf)
      k = Checkability.const_get conf[:name].to_s.camelize
      k.new(conf)
    end
  end
end
