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
          raise ArgumentError, "Hash expected, got #{options.class.name}"
        end

        class_attribute :checkable_conf

        self.checkable_conf = options
      end
    end

    attr_accessor :allowed, :messages

    def perform_check
      _setup
      self.allowed = _check
      messages << "'#{value}' is #{_allowness}. "
    end

    private

    def _setup
      self.allowed = nil
      self.messages = []
    end

    def _allowness
      allowed ? 'ALLOWED' : 'NOT allowed'
    end

    def _check
      Checkability::Checkable.new(self).check(checkable_conf)
    end
  end
end
