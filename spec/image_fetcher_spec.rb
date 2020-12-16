# frozen_string_literal: true

require "./../lib/image_fetcher"
require "./../lib/error_logger"

RSpec.describe ImageFetcher do
  subject(:service) { described_class.call(params) }

  let(:params)       { { url: url, error_logger: error_logger } }
  let(:url)          { "http://somewebsrv.com/img/992147.jpg" }
  let(:error_logger) { ErrorLogger.new }
  let(:image)        { double("image") }

  before do
    allow(image).to        receive(:open)
    allow(image).to        receive(:path).and_return(url)
    allow(URI).to          receive(:parse).and_return(image)
    allow(File).to         receive(:open)
    allow(error_logger).to receive(:log)
  end

  it "saves image into a file" do
    expect(File).to receive(:open)

    service
  end

  context "with invalid url" do
    before do
      allow(URI).to receive(:parse).and_raise(URI::InvalidURIError)
    end

    it "logs the error message" do
      expect(error_logger).to receive(:log)

      service
    end
  end
end
