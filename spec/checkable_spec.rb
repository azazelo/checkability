# frozen_string_literal: true

require_relative '../lib/checkability'

def klass
  Checkability::Checkable
end

RSpec.describe klass, :aggregate_failure do
  before(:each) { setup_db }
  after(:each)  { teardown_db }

  let!(:obj) { Check.create(value: 'SE17QD') }
  let!(:checkable) { klass.new(obj) }

  context "when #check with @value = 'SE17QD'" do
    it 'valid by Postcode regex' do
      expect(checkable.check(validator_conf)).to be(true)
    end
    it 'can not found it in storage' do
      expect(checkable.check(storage_conf)).to be(false)
    end
    it 'can found it in external API' do
      expect(checkable.check(api_finder_conf)).to be(true)
    end
    it 'valid in external API' do
      expect(checkable.check(api_validator_conf)).to be(true)
    end
  end
end
