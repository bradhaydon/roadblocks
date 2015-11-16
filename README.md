# Roadblocks

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'roadblocks'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install roadblocks

## Usage

### Create a migration for the roadblocks gem

```
bundle exec rails generate add_roadblocks_to_users can_display:boolean roadblock_errors:text
```

### Run the pending migrations

```
bundle exec rake db:migrate
```

### Add roadblocks to your model
```
class User < ActiveRecord::Base
	include Roadblocks
	
	roadblocks_for(:can_display) do
   		roadblock_rule("hasn't been approved") { approved? }
   		roadblock_rule("doesn't have an avatar") { avatar.present? }
    	roadblock_rule("address is missing") { address.present? }
	end
  end

end
```

### Working with roadblocks

```
> user.can_display?
=> false

> user.approved?
=> false

> user.roadblock_errors[:can_display]
=> ["hasn't been approved"]

> user.update_attribute(:approved, true)

> user.can_display?
=> true

> user.roadblock_errors.empty?
=> true
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/roadblocks. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
