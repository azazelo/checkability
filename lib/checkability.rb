require "active_record"
require "active_support"
require "checkability/checkable"
require "checkability/storage_checker"
require "checkability/external_api_checker"
require "checkability/external_api_connector"
require "checkability/validator"
require_relative "checkability/acts_as_checkable"

include Checkability::ActsAsCheckable

