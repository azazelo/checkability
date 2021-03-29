# Checks if postcode exists in Storage
#
class StorageChecker
  attr_reader :storage_class
  
  def initialize(conf)
    @storage_class = conf[:storage_class]
  end
  
  def check_value(checkable)
    result = 
      storage_class
      .where(value: checkable.value)
      .or(Postcode.where(value: checkable.value.gsub(' ','')))
    checkable.results << [true, "Allowed #{storage_class}s list: Found."] if result.present?
    checkable.results << [false, "Allowed #{storage_class}s list: Not found."] if result.empty?
  end
end
