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

    private

    def _result(checkable)
      value = _normalize_value(checkable.send(attr_name))
      storage_class.where(attr_name => value).present?
    end

    def message(str, res)
      str = "Allowed #{storage_class}s list: #{str}"
      super(str, res)
    end

    def _normalize_value(value)
      value.delete(' ').upcase
    end
  end
end
