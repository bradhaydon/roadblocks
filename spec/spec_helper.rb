$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'roadblocks'
require 'active_record'
require 'factory_girl'
require 'forgery'
require 'pry'
ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => ":memory:"
)

Dir[File.dirname(__FILE__) + "/factories/**/*.rb"].each {|f| require f }
Dir[File.dirname(__FILE__) + "/models/**/*.rb"].each {|f| require f }
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
