# frozen_string_literal: true

require 'active_record'
require 'active_support'
require_relative 'checkability/version'
require_relative 'checkability/checkable'
require_relative 'checkability/storage_checker'
require_relative 'checkability/external_api_checker'
require_relative 'checkability/external_api_connector'
require_relative 'checkability/validator'
require_relative 'checkability/acts_as_checkable'
require_relative 'checkability/chain_of_resp/handler'
require_relative 'checkability/chain_of_resp/abstract_handler'

ActiveRecord::Base.include Checkability::ActsAsCheckable
