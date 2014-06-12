module VcrHelpers
  def use_http_recordings
    before { VCR.insert_cassette cassette, :record => :new_episodes }
    after  { VCR.eject_cassette }
  end
end
