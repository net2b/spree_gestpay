require 'vcr'

RSpec.configure do |config|
  config.raise_errors_for_deprecations!
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/gestpay_cassettes'
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
end

def use_http_recordings
  before { VCR.insert_cassette cassette, :record => :new_episodes }
  after  { VCR.eject_cassette }
end
