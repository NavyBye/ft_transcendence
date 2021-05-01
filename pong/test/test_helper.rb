ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    # NOT storing uploads in the tests
    # CarrierWave::Mount::Mounter.class_eval { def store!; end }
    CarrierWave::Mounter.class_eval { def store!; end }
    CarrierWave.root = Rails.root.join('test/fixtures/files')
    def after_teardown
      super
      CarrierWave.clean_cached_files!(0)
    end
  end
end
