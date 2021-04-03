# frozen_string_literal: true

require_relative 'abstract_checker'
module Checkability
  # Checks if postcode exists in Storage
  #
  class StorageChecker < AbstractChecker
    attr_reader :storage_class

    def post_initialize(conf = {})
      @storage_class = conf[:storage_class]
    end

    def result_and_message(checkable)
      value = checkable.value.upcase
      result = _present_in_storage(value)
      message = 
        (result ? message('Found', result) : message('Not found', result))
      [result, message]
    rescue StandardError => e
      [false, message(e, false)]
    end
    
    private

    def _present_in_storage(value)
      storage_class.where(value: value)
                   .or(storage_class.where(value: value.strip))
                   .or(storage_class.where(value: value.delete(' ')))
                   .present?
    end

    def message(str, res)
      str = "Allowed #{storage_class}s list: #{str}" 
      super(str, res)
    end
  end
end
