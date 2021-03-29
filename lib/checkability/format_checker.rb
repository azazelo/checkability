# Checks if postcode exists in Storage
#
class FormatChecker
  def check_value(checkable)
    checkable.formats.map do |format|
      !(checkable.value =~ format).nil?
    end.all?
  end
end

