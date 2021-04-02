# frozen_string_literal: true

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3', database: ':memory:'
)
ActiveRecord::Schema.verbose = false

def setup_db
  ActiveRecord::Schema.define(version: 1) do
    create_table :postcodes do |t|
      t.string :value

      timestamps t
    end
    create_table :checks do |t|
      t.string :value

      timestamps t
    end
  end
end

def timestamps(table)
  table.column  :created_at, :timestamp, null: false
  table.column  :updated_at, :timestamp, null: false
end

def teardown_db
  ActiveRecord::Base.connection.data_sources.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

class Check < ActiveRecord::Base
  acts_as_checkable
end

class Postcode < ActiveRecord::Base
end

def validator_conf
  { name: :validator,
    format: {
      name: 'UK Postcodes',
      regex: /([a-z]{1,2}[0-9]{1,2})([a-z]{1,2})?(\W)?([0-9]{1,2}[a-z]{2})?/i
    },
    stop_process_if_failure: true }
end

def api_validate_conf
  { name: :external_api_checker,
    path: 'http://api.postcodes.io/postcodes/',
    http_verb: :get,
    path_suffix: '/validate',
    check_method: proc { |result_hash|
      result_hash['result'] == true
    },
    stop_process_if_failure: true,
    success_message: 'Postcode IS VALID.',
    failure_message: 'Postcode IS NOT VALID.' }
end

def api_inside_district_conf
  { name: :external_api_checker,
    path: 'http://api.postcodes.io/postcodes/',
    check_method: proc { |result_hash|
      %w[Southwark Lambeth].include?(result_hash['result']['admin_district'])
    },
    stop_process_if_success: true,
    success_message: 'Postcode IS INSIDE allowed areas.',
    failure_message: 'Postcode IS NOT INSIDE of allowed areas.' }
end

def storage_checker_conf
  { name: :storage_checker,
    storage_class: Postcode,
    stop_process_if_success: true }
end
