# frozen_string_literal: true

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
  context 'when input is valid postcode' do
    specify 'message included `COMPLY`' do
      check_valid_postcode.ch_messages = []
      validator.handle(check_valid_postcode)
      expect(check_valid_postcode.ch_messages).to include(/COMPLY/)
    end
  end
  let(:check_invalid_postcode) { Check.new(value: 'sss') }
  context 'when input is invalid postcode' do
    specify 'message included `NOT COMPLY`' do
      check_invalid_postcode.ch_messages = []
      validator.handle(check_invalid_postcode)
      expect(check_invalid_postcode.ch_messages).to include(/NOT COMPLY/)
    end
  end
end
