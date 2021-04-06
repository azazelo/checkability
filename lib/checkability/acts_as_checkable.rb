# frozen_string_literal: true

module Checkability
  # Adding class and instance methods
  #
  module ActsAsCheckable
    def self.included(base)
      base.extend ClassMethods
    end

    extend ActiveSupport::Concern

    class_methods do
      def acts_as_checkable(options = {})
        if !options.is_a?(Hash) && !options.empty?
          raise ArgumentError,
                "Hash expected, got #{options.class.name}"
        end

        class_attribute :ch_conf

        self.ch_conf = options
      end
    end

    attr_accessor :ch_allowed, :ch_messages, :ch_conf

    def initialize(params)
      @ch_messages = []
      @ch_allowed = nil
      super(params)
    end

    def perform_check
      @ch_conf = ch_conf
      Checkability::Checkable.new(self).check
      ch_messages << "#{ch_allowed}:::'#{_value}' is #{_allowness}. "
    end

    private

    def _value
      send(_attr_name)
    end

    def _attr_name
      ch_conf[:attr_name] || :value
    end

    def _allowness
      ch_allowed ? 'ALLOWED' : 'NOT allowed'
    end
  end
end
