# frozen_string_literal: true

# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative '../lib/checkability'

RSpec.describe Checkability::ActsAsCheckable do
  setup_db
  describe 'respond to' do
    it '#perform_check' do
      check_double = instance_double('Check')
      allow(check_double).to receive(:perform_check)
      check_double.perform_check
    end

    it '.acts_as_checkable' do
      klass = class_double('Check')
      allow(klass).to receive(:acts_as_checkable)
      klass.acts_as_checkable
    end

    #    describe 'have attributes' do
    #
    #      it '@ch_messages' do
    #        record = instance_double('Record')
    #        klass = class_double('Record')
    #        allow(klass).to receive(:acts_as_checkable)
    #        klass.acts_as_checkable
    #      end
    #    end
  end
  teardown_db
end
