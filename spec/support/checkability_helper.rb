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
    next_handler: 'Storage',
    stop_process_on_failure: true,

    format: {
      name: 'UK Postcodes',
      regex: /([a-z]{1,2}[0-9]{1,2})([a-z]{1,2})?(\W)?([0-9]{1,2}[a-z]{2})?/i
    } }
end

def storage_conf
  { name: :storage_checker,
    next_handler: 'ApiValidator',
    stop_process_on_success: true,

    storage_class: Postcode }
end

def api_validator_conf
  { next_handler: 'ApiFinder',
    name: :external_api_checker,
    stop_process_on_failure: true,

    path: 'http://api.postcodes.io/postcodes/',
    http_verb: :get,
    path_suffix: '/validate',
    check_method: proc { |result_hash|
      result_hash['result'] == true
    },
    success_message: 'Postcode IS VALID.',
    failure_message: 'Postcode IS NOT VALID.' }
end

def api_finder_conf
  { name: :external_api_checker,
    next_handler: nil,
    stop_process_on_success: true,

    path: 'http://api.postcodes.io/postcodes/',
    check_method: proc { |result_hash|
      District.pluck(:name).include?(result_hash['result']['admin_district'])
    },
    success_message: 'Postcode IS INSIDE allowed areas.',
    failure_message: 'Postcode IS NOT INSIDE of allowed areas.' }
end
