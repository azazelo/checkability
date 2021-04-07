# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'External request' do
  it 'queries postcodes.io' do
    uri = URI('https://api.postcodes.io/postcodes/se17qd')
    FakeWeb.register_uri(:get,
                         uri,
                         body: '{"status":200,"result":{"admin_district": "Southwark"} }')

    response = Net::HTTP.get(uri)

    expect(response).to be_an_instance_of(String)
  end
end
