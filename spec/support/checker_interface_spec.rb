# frozen_string_literal: true

require 'spec_helper'

RSpec.shared_examples 'Checker', :aggregate_failures do |checker_class|
  let(:object) { checker_class.new }
  it 'implemets the checker interface' do
    expect(object).to respond_to(:next_handler=)
    expect(object).to respond_to(:handle)
    expect(object).to respond_to(:result_and_message)
    expect(object).to respond_to(:result)
    expect(object).to respond_to(:message)
  end
end
