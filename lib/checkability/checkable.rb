# Checks if postcode exists in Storage
#
class Checkable
  attr_reader :checkable

  def initialize(checkable)
    @checkable = checkable
  end

  # sentence is a proc 
  #   like { |a,b,c| a && ( b || c ) } 
  #   where a,b,c are checkers 
  #   and each should return [true, message] or [false, message]
  # checkers is an array of checker objects
  #   e.g. [storage_checker, external_api_checker]
  def check(sentence, checkers)
    checkers.each do |checker| 
      checker.check_value(checkable)
    end
    sentence.call checkable.results.map{ |i| i[0] } 
  end
end