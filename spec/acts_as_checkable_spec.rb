# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative '../lib/checkability'
require 'pry'

RSpec.describe Checkability::ActsAsCheckable do
  setup_db
  #  before(:each) do
  #    conf = { storage_class: Struct.new(:value) }
  #    @object = @storage_checker = StorageChecker.new(conf)
  #  end

  describe 'respond to method' do
    it 'calls perform_check method' do
      record = instance_double('Record')
      allow(record).to receive(:perform_check)
      record.perform_check
    end

    #  let!(:postcode) { Postcode.create(value: 'S24 1AA') }
    #  it '#perform', :aggregate_failures do
    #    check.perform
    #    expect(check).to receive
    #    expect(check.messages).to be_a(Array)
    #    expect(check.messages).to include(/ALLOWED/)
    #  end

    it 'calls acts_as_checkable method' do
      klass = class_double('Record')
      allow(klass).to receive(:acts_as_checkable)
      klass.acts_as_checkable
    end
  end

  #  it_behaves_like 'Checker', Checkability::Validator
end
