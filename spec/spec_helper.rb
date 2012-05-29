require 'rubygems'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'active_support/all'
require "mongoid"
require "mocha"
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

# Set the database that the spec suite connects to.
Mongoid.configure do |config|
  config.connect_to(database_id)
end

class Movie
  include Mongoid::Document
  include Mongoid::TaggableOn

  taggable_on :actors, :index => false
  taggable_on :directors
  taggable_on :countries
  taggable_on :categories

  field :title
  field :summary
end

RSpec.configure do |config|
  config.mock_with :mocha
  config.after :suite do
    Mongoid.purge!
    Mongoid::IdentityMap.clear
    if ENV["CI"]
      Mongoid::Threaded.sessions[:default].drop
    end
  end
end