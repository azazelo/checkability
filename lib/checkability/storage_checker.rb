# Checks if postcode exists in Storage
#
module Checkability
  class StorageChecker
    attr_reader :storage_class

    def initialize(conf={})
      @storage_class = conf[:storage_class]
    end

    def check_value(checkable)
      value = checkable.value.upcase
      result = 
        storage_class.where(     value: value )
        .or( storage_class.where(value: value.strip) )
        .or( storage_class.where(value: value.gsub(' ','')) )
        .present?
      checkable.messages << (result ? _message('Found') : _message('Not found'))
      result
    end

    def _message(str)
      "Allowed #{storage_class}s list: #{str}."
    end
  end
end