# frozen_string_literal: true

require_relative '../lib/checkability'

def klass
  Checkability::Checkable
end

RSpec.describe klass, :aggregate_failure do
  before(:each) { setup_db }
  after(:each)  { teardown_db }

  let!(:obj) { Check.create(value: 'SE1 7QD') }
  let!(:checkable) { klass.new(obj) }
  let!(:strategy) { proc { |a| a == true } }

  context "when #check with @value = 'SE1 7QD'" do
    it 'valid by Postcode regex' do
      expect(checkable.check(strategy: strategy,
                             checker_confs: [validator_conf])).to be(true)
    end
    it 'can not found it in storage' do
      expect(checkable.check(strategy: strategy,
                             checker_confs: [storage_checker_conf])).to be(false)
    end
    it 'can found it in external API' do
      expect(checkable.check(strategy: strategy,
                             checker_confs: [api_inside_district_conf])).to be(true)
    end
    it 'valid in external API' do
      expect(checkable.check(strategy: strategy,
                             checker_confs: [api_validate_conf])).to be(true)
    end
  end
end
