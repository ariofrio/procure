require 'rspec'

require 'unindent'
require 'equivalent-xml'
require 'fakefs/safe'
require 'fakefs/spec_helpers'

$:.unshift File.expand_path("../../lib", __FILE__)

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.color_enabled = true
  config.order = 'rand'
  config.include FakeFS::SpecHelpers, :fakefs
  # config.mock_with :rr
end