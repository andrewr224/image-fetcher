# frozen_string_literal: true

require "./lib/service"
require "./lib/image_fetcher"

class ImageFetcherOrganizer < Service
  def initialize(filenames:, error_logger:)
    @filenames    = filenames
    @error_logger = error_logger
  end

  def call
    filenames.each(&method(:fetch_for_file))
  end

  private

  attr_reader :filenames, :error_logger

  def fetch_for_file(filename)
    File.foreach(filename).map(&:strip).each(&method(:fetch_for_url))
  rescue Errno::ENOENT
    error_logger.log(error: "File '#{filename}' doesn't exist!")
  rescue Errno::EPIPE
    exit
  end

  def fetch_for_url(url)
    ImageFetcher.call(url: url, error_logger: error_logger)
  end
end
