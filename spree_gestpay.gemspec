# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform     = Gem::Platform::RUBY
  s.name         = 'spree_gestpay'
  s.version      = '1.3.5'
  s.summary      = 'GestPay Integration for Spree'

  s.author       = 'Stefano Pigozzi'
  s.email        = 'stefano.pigozzi@gmail.com'
  s.require_path = 'lib'
  s.requirements << 'none'

  s.required_ruby_version = '>= 2.1.1'

  s.add_dependency 'spree_core',     '~> 2.4'
  s.add_dependency 'spree_frontend', '~> 2.4'
  s.add_dependency 'savon',          '~> 2.6'

  s.add_development_dependency 'vcr',                '~> 2.9.2'
  s.add_development_dependency 'webmock',            '~> 1.18.0'
  s.add_development_dependency 'capybara', '~> 2.4'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.5'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 3.1'
  s.add_development_dependency 'sass-rails', '~> 4.0.2'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'poltergeist', '~> 1.6.0'
  s.add_development_dependency 'launchy', '~> 2.4.3'
end
