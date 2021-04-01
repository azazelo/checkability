# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative '../lib/checkability'

RSpec.describe Checkability::ActsAsCheckable do
  setup_db
  describe 'respond to method' do
    it 'calls perform_check method' do
      record = instance_double('Record')
      allow(record).to receive(:perform_check)
      record.perform_check
    end

    it 'calls acts_as_checkable method' do
      klass = class_double('Record')
      allow(klass).to receive(:acts_as_checkable)
      klass.acts_as_checkable
    end
  end
  teardown_db
end
