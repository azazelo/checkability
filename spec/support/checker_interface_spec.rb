# frozen_string_literal: true

require 'spec_helper'

RSpec.shared_examples 'Checker' do |checker_class|
  let(:object) { checker_class.new }
  it 'implemets the checker interface' do
    expect(object).to respond_to(:result)
  end
end
