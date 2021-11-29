require 'bundler/setup'
require 'invalid_record_finder'

ENV['RAILS_ENV'] ||= 'test'
require_relative File.join('dummy_rails_app', 'config', 'environment')

load Rails.root.join('db', 'schema.rb')

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
