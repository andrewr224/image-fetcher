# frozen_string_literal: true

require "./../lib/image_fetcher_organizer"

RSpec.describe ImageFetcherOrganizer do
  subject(:service) { described_class.call(params) }

  let(:params)       { { filenames: filenames, error_logger: error_logger } }
  let(:filenames)    { ["test.txt"] }
  let(:error_logger) { ErrorLogger.new }
  let(:count)        { rand(1..10) }

  let(:urls) { count.times.map { "http://mywebserver.com/images/271947.jpg" } }

  before do
    allow(File).to receive(:foreach).and_return(urls)
    allow(ImageFetcher).to receive(:call)
    allow(error_logger).to receive(:log)
  end

  it "calls ImageFetcher to fetch every url" do
    expect(ImageFetcher).to receive(:call).exactly(count).times

    service
  end

  context "with invalid filename" do
    before do
      allow(File).to receive(:foreach).and_raise(Errno::ENOENT)
    end

    it "logs the error message" do
      expect(error_logger).to receive(:log)

      service
    end
  end
end
