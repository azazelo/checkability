require 'spec_helper'

RSpec.describe 'External request' do
  it 'queries postcodes.io' do
    uri = URI('https://api.postcodes.io/postcodes/se17qd')

    response = Net::HTTP.get(uri)

    expect(response).to be_an_instance_of(String)
  end
end