# frozen_string_literal: true

# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative '../lib/checkability'
require 'support/checker_interface_spec'

RSpec.describe Checkability::ExternalApiChecker do
  before(:each) { setup_db }
  after(:each) { teardown_db }

  it_behaves_like 'Checker', Checkability::ExternalApiChecker

  let(:external_api_checker) do
    Checkability::ExternalApiChecker.new(api_validate_conf)
  end
  let(:check_true_postcode) { Check.new(value: 'SE17QD') }
  context 'when input a REAL postcode' do
    it 'respond with success' do
      check_true_postcode.messages = []
      expect(external_api_checker.check_value(check_true_postcode)).to eq(true)
      expect(check_true_postcode.messages).to include(/IS VALID/)
    end
  end
  let(:check_fake_postcode) { Check.new(value: 'SH241AA') }
  context 'when input a FAKE postcode' do
    it 'respond with failure' do
      check_fake_postcode.messages = []
      expect(external_api_checker.check_value(check_fake_postcode)).to eq(false)
      expect(check_fake_postcode.messages).to include(/IS NOT VALID/)
    end
  end
end

RSpec.describe Checkability::ExternalApiChecker do
  before(:each) { setup_db }
  after(:each) { teardown_db }

  it_behaves_like 'Checker', Checkability::ExternalApiChecker

  let(:external_api_checker) do
    Checkability::ExternalApiChecker.new(api_inside_district_conf)
  end
  let(:check_included_postcode) { Check.new(value: 'SE17QD') }
  context 'when input a INCLUDED postcode' do
    it 'respond with success' do
      check_included_postcode.messages = []
      expect(external_api_checker.check_value(check_included_postcode))
        .to be_truthy
      expect(check_included_postcode.messages).to include(/IS INSIDE/)
    end
  end
  let(:check_excluded_postcode) { Check.new(value: 'RM30PD') }
  context 'when input a EXCLUDED postcode' do
    it 'respond with failure' do
      check_excluded_postcode.messages = []
      expect(external_api_checker.check_value(check_excluded_postcode))
        .to eq(false)
      expect(check_excluded_postcode.messages).to include(/IS NOT INSIDE/)
    end
  end
end
