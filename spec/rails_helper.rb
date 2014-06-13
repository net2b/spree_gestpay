# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path('../dummy/config/environment',  __FILE__)
require 'rspec/rails'
require 'database_cleaner'
require 'ffaker'

# Requires factories defined in spree_core
require 'spree/core/testing_support/factories'
require 'spree/core/testing_support/controller_requests'
require 'spree/core/testing_support/authorization_helpers'
require 'spree/core/url_helpers'
require 'spree_gestpay/factories'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Spree::Core::UrlHelpers
  config.include RSpec::Rails::RequestExampleGroup, type: :controller
  config.include KeepOpenHelpers, type: :feature

  config.mock_with :rspec
  config.color = true
  config.use_transactional_fixtures = false

  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  config.before do
    DatabaseCleaner.strategy = RSpec.current_example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end
