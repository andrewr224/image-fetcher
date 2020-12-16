# frozen_string_literal: true

require "open-uri"
require "./lib/service"

class ImageFetcher < Service
  def initialize(url:, error_logger:)
    @url          = url
    @error_logger = error_logger
  end

  def call
    URI.parse(url).open.tap(&method(:save_image))
  rescue URI::InvalidURIError, OpenURI::HTTPError, Net::OpenTimeout
    error_logger.log(error: "URL '#{url}' is broken!")
  end

  private

  attr_reader :url, :error_logger

  def save_image(image)
    File.open(file_name, "wb") do |file|
      file.write(image.read)
    end
  end

  def file_name
    URI.parse(url).path.split("/").last
  end
end
