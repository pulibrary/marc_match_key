# frozen_string_literal: true

# This must be first!
if ENV['CI'] || ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'spec'
  end
end

require 'marc_match_key'
require 'byebug'
require 'coveralls'
require 'simplecov'

SimpleCov.start do
  add_filter 'spec'
end
Coveralls.wear!

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
