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
  
  let(:validator_conf) do
    {
      name: :validator,
      format: {
        name: 'UK Postcodes',
        regex: /([a-z]{1,2}[0-9]{1,2})([a-z]{1,2})?(\W)?([0-9]{1,2}[a-z]{2})?/i
      },
      stop_process_if_failure: true
    }
  end
  
  let(:check_valid_postcode) { Check.new(value: 'SH241AA') }
  let(:validator) {Checkability::Validator.new(validator_conf)}
  context 'when input' do
    specify 'valid postcode' do
      check_valid_postcode.messages = []
      expect(validator.check_value(check_valid_postcode)).to eq(true)
      expect(check_valid_postcode.messages).to include(/COMPLY/)
    end
  end
  
end
