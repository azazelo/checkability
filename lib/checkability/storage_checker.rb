# frozen_string_literal: true

require_relative 'abstract_checker'
module Checkability
  # Checks if postcode exists in Storage
  #
  class StorageChecker < AbstractChecker
    attr_reader :storage_class, :attr_name

    def post_initialize(conf = {})
      @storage_class = conf[:storage_class]
      @attr_name = conf[:attr_name] || :value
    end

    def result(checkable)
      value = _normalize_value(checkable.send(attr_name))
      storage_class.where(attr_name => value).present?
    end

    def message(res, str = '')
      "#{res}::Allowed #{storage_class}s list: #{str}"
    end
    
    private

    def _normalize_value(value)
      value.delete(' ').upcase
    end
  end
end
