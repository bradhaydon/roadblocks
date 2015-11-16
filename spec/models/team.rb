ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS teams")
ActiveRecord::Base.connection.create_table(:teams) do |t|
  t.string :name
  t.boolean :active
  t.boolean :displayable
  t.text :roadblock_errors
end

class Team < ActiveRecord::Base
  include Roadblocks
  serialize :roadblock_errors
  has_many :players, autosave: true

  roadblocks_for(:displayable) do
    roadblock_rule('The team name cannot begin with the word red') { name.match(/^Red/).blank? }
  end
end

FactoryGirl.define do
  factory :team do
    name Forgery::LoremIpsum.text(:words, 5)
  end

  trait :is_eligible do
  end

  trait :is_not_eligible do
    name 'Red Devils'
  end
end
