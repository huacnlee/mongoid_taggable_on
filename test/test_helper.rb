# frozen_string_literal: true

require "minitest/autorun"
require "rails/all"
require "mongoid"
require "mongoid_taggable_on"
require "uri"

# These environment variables can be set if wanting to test against a database
# that is not on the local machine.
ENV["MONGOID_SPEC_HOST"] ||= "localhost"
ENV["MONGOID_SPEC_PORT"] ||= "27017"

# These are used when creating any connection in the test suite.
HOST = ENV["MONGOID_SPEC_HOST"]
PORT = ENV["MONGOID_SPEC_PORT"].to_i

def database_id
  ENV["CI"] ? "mongoid_aii_#{Process.pid}" : "mongoid_aii_test"
end
Mongoid.logger.level = Logger::INFO
Mongo::Logger.logger.level = Logger::INFO
# Set the database that the spec suite connects to.
Mongoid.configure do |config|
  config.connect_to(database_id)
  config.log_level = :info
end


class Movie
  include Mongoid::Document
  include Mongoid::TaggableOn

  taggable_on :actors, index: false
  taggable_on :directors
  taggable_on :countries
  taggable_on :categories

  field :title
  field :summary
end

class ActiveSupport::TestCase
  teardown do
    Mongoid.purge!
    Mongoid::Threaded.sessions[:default].drop if ENV["CI"]
  end
end
