# frozen_string_literal: true

# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative '../lib/checkability'
require 'support/checker_interface_spec'

RSpec.describe Checkability::ExternalApiChecker, :vcr do
  before(:each) { setup_db }
  after(:each) { teardown_db }

  it_behaves_like 'Checker', Checkability::ExternalApiChecker

  let(:external_api_checker) do
    Checkability::ExternalApiChecker.new(api_validator_conf)
  end
  let(:check_true_postcode) { Check.new(value: 'SE17QD') }
  context 'when input a REAL postcode' do
    it 'respond with success' do
#      connector_class_double = class_double('Checkability::ExternalApiConnector')
#      allow(connector_class_double).to receive(:new).with("path").and_return('faraday')
#      connector_double = instance_double('Checkability::ExternalApiConnector')
#      get_struct = Struct.new(:get).new(200)
#      allow(connector_double).to receive(:connection).and_return(get_struct)
#      
#      
#      checker = Checkability::ExternalApiChecker.new(api_validator_conf.merge({
#            connector: connector_double
#          }))
#      
#      
#      checker.handle(check_true_postcode)
      
#      external_api_checker.handle(check_true_postcode)
#      expect(check_true_postcode.ch_messages).to include(/IS VALID/)
    end
  end
  let(:check_fake_postcode) { Check.new(value: 'SH241AA') }
  context 'when input a FAKE postcode' do
    it 'respond with failure' do
      
      external_api_checker.handle(check_fake_postcode)
      expect(check_fake_postcode.ch_messages).to include(/IS NOT VALID/)
    end
  end
end

RSpec.describe Checkability::ExternalApiChecker do
  before(:each) { setup_db }
  after(:each) { teardown_db }

  it_behaves_like 'Checker', Checkability::ExternalApiChecker

  #  let(:api_validator) do
  #    Checkability::ExternalApiChecker.new(api_validator_conf)
  #  end
  let(:api_finder) do
    Checkability::ExternalApiChecker.new(api_finder_conf)
  end
  let(:check_included_postcode) { Check.new(value: 'SE17QD') }
  context 'when input a INCLUDED postcode' do
    it 'message included `IS INSIDE`' do
      check_included_postcode.ch_messages = []
      api_finder.handle(check_included_postcode)
      expect(check_included_postcode.ch_messages).to include(/IS INSIDE/)
    end
  end
  let(:check_excluded_postcode) { Check.new(value: 'RM30PD') }
  context 'when input a EXCLUDED postcode' do
    it 'message included `IS NOT INSIDE`' do
      check_excluded_postcode.ch_messages = []
      api_finder.handle(check_excluded_postcode)
      expect(check_excluded_postcode.ch_messages).to include(/IS NOT INSIDE/)
    end
  end
end
