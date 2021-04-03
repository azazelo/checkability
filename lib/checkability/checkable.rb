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
    def check(opts)
      handler_confs = opts[:handler_confs]
      first_handler_name = opts[:first_handler]
      first_handler = _handlers(handler_confs)[first_handler_name]

      first_handler.handle(checkable)
      #    rescue StandardError => e
      #      checkable.messages << "false::#{e}: #{opts}."
      #      false
    end

    private

    def _handlers(handler_confs)
      handlers = _make_handlers(handler_confs)
      handlers.each do |handler_name, handler|
        next_handler_name = handler_confs[handler_name][:next_handler]
        handler.next_handler(handlers[next_handler_name]) if handlers[next_handler_name]
      end
    end

    def _make_handlers(handler_confs)
      handler_confs.transform_values do |handler_conf|
        _make_handler(handler_conf)
      end
    end

    def _make_handler(conf)
      k = Checkability.const_get conf[:name].to_s.camelize
      k.new(conf)
    end
  end
end
