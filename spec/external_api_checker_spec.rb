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

  let(:check_real_postcode) { Check.new(value: 'SE17QD') }
  context 'when input a REAL postcode' do
    it 'respond with success' do
      fw(check_real_postcode.value, api_validator_conf, '{"status":200,"result":true}')
      external_api_checker.handle(check_real_postcode)
      expect(check_real_postcode.ch_messages).to include(/IS VALID/)
    end
  end
  let(:check_fake_postcode) { Check.new(value: 'SH241AA') }
  context 'when input a FAKE postcode' do
    it 'respond with failure' do
      fw(check_fake_postcode.value, api_validator_conf, '{"status":200,"result":false}')
      external_api_checker.handle(check_fake_postcode)
      expect(check_fake_postcode.ch_messages).to include(/IS NOT VALID/)
    end
  end
end

RSpec.describe Checkability::ExternalApiChecker do
  before(:each) { setup_db }
  after(:each) { teardown_db }

  it_behaves_like 'Checker', Checkability::ExternalApiChecker

  let(:api_finder) { Checkability::ExternalApiChecker.new(api_finder_conf) }
  let(:check_included_postcode) { Check.new(value: 'SE17QD') }
  context 'when input a INCLUDED postcode' do
    it 'message included `IS INSIDE`' do
      fw(check_included_postcode.value, api_finder_conf,
         '{"status":200,"result":{"admin_district": "Southwark" } }')
      check_included_postcode.ch_messages = []
      api_finder.handle(check_included_postcode)
      expect(check_included_postcode.ch_messages).to include(/IS INSIDE/)
    end
  end
  let(:check_excluded_postcode) { Check.new(value: 'RM30PD') }
  context 'when input a EXCLUDED postcode' do
    it 'message included `IS NOT INSIDE`' do
      fw(check_excluded_postcode.value, api_finder_conf,
         '{"status":200,"result":{"admin_district": "Havering" } }')
      check_excluded_postcode.ch_messages = []
      api_finder.handle(check_excluded_postcode)
      expect(check_excluded_postcode.ch_messages).to include(/IS NOT INSIDE/)
    end
  end
end
