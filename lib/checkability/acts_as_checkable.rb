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

        class_attribute :checkable_conf

        self.checkable_conf = options
      end
    end

    attr_accessor :allowed, :messages

    def perform_check
      self.allowed = nil
      self.messages = []
      self.allowed = Checkability::Checkable.new(self).check(checkable_conf)
      messages << "#{allowed}::'#{_value}' is #{_allowness}. "
    end

    private

    def _value
      send(_attr_name)
    end

    def _attr_name
      checkable_conf[:attr_name] || :value
    end

    def _setup; end

    def _allowness
      allowed ? 'ALLOWED' : 'NOT allowed'
    end
  end
end
