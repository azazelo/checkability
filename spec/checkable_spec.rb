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
      #      expect(checkable.check( { first_handler: 'Validator',
      #            handler_confs: { 'Validator' => validator_conf } } ) ).to be(true)
      expect(checkable.check(uk_postcode_checkers_conf)).to be(true)
    end
  end
end
