# frozen_string_literal: true

class Service
  def self.call(*args)
    new(*args).call.tap do |result|
      return yield(result) if block_given?
    end
  end
end
