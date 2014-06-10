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
  s.add_dependency 'spree_core', '~> 1.3.5'
  s.add_dependency 'savon',      '~> 2.5.1'

  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'selenium-webdriver'

  s.add_development_dependency 'capybara',           '~> 2.1'
  s.add_development_dependency 'rspec-rails',        '~> 3.0.0'
  s.add_development_dependency 'vcr',                '~> 2.9.2'
  s.add_development_dependency 'webmock',            '~> 1.18.0'
  s.add_development_dependency 'factory_girl_rails', '~> 1.7.0'
end
