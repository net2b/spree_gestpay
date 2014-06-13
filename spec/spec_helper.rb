require 'vcr'

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.raise_errors_for_deprecations!
  config.extend VcrHelpers
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/gestpay_cassettes'
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
end
