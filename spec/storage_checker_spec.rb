# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative '../lib/checkability'
require 'support/checker_interface_spec'

RSpec.describe StorageChecker do
#  before(:each) do
#    @object = @storage_checker = StorageChecker.new
#  end
  
  it_behaves_like 'Checker', StorageChecker
end

