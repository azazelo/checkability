# Checks if postcode exists in Storage
#
class Validator
  attr_reader :formats
  
  def initialize(conf)
    @formats = conf[:formats]
  end
  
  def check_value(checkable)
    formats.each do |format|
      checkable.results << 
        if (checkable.value =~ format[:regex]).nil?
          [false, "value is not comply with format of #{format[:name]}."]
        else
          [true, "Value comply with format of #{format[:name]}."]
        end
    end
  end
end
