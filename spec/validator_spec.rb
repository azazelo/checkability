# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative '../lib/checkability'
require 'support/checker_interface_spec'

RSpec.describe Checkability::Validator, :aggregate_failure do
  before(:each) do
    setup_db
  end
  after(:each) do
    teardown_db
  end

  it_behaves_like 'Checker', Checkability::Validator

  let(:validator) { Checkability::Validator.new(validator_conf) }
  let(:check_valid_postcode) { Check.new(value: 'SH241AA') }
  context 'when input' do
    specify 'valid postcode' do
      check_valid_postcode.messages = []
      expect(validator.check_value(check_valid_postcode)).to eq(true)
      expect(check_valid_postcode.messages).to include(/COMPLY/)
    end
  end
  let(:check_invalid_postcode) { Check.new(value: 'sss') }
  context 'when input' do
    specify 'invalid postcode' do
      check_invalid_postcode.messages = []
      expect(validator.check_value(check_invalid_postcode)).to eq(false)
      expect(check_invalid_postcode.messages).to include(/NOT COMPLY/)
    end
  end
end
