# Checks if postcode exists in Storage
#


module Checkability
  module ActsAsCheckable
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
    def setup
      self.allowed = nil
      self.messages = []
    end

    def perform
      setup
      self.allowed = _check
      self.messages << "#{self.class.name} '#{value}' is #{_allowness}. "
    end

    def _allowness
      self.allowed ? 'ALLOWED' : 'NOT allowed'
    end

    def _check
      Checkability::Checkable.new(self)
      .check(self.checkable_conf)
#      .check(
#        proc { |a, b, c| a && ( b || c ) },
#        [ 
#          Checkability::Validator.new(validator_conf),
#          Checkability::StorageChecker.new(storage_conf), 
#          Checkability::ExternalApiChecker.new(external_api_checker_conf)
#        ]
#      )
    end
  end
end