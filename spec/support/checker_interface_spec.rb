require 'spec_helper'

RSpec.shared_examples 'Checker interface' do |checker_class|
  let(:object) { checker.class.new }
  it 'implemets the checker interface' do    
    expect(object).to respond_to(:check_value)
  end
end
