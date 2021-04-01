# Checkability

Add to application checkers functionality  
  
Checker could be any object of Ruby 
which respond to method check_value  
with return of true|false

## Usage
How to use my plugin.

inside of any rails model do
```ruby
class SomeModel
  acts_as_checkable strategy: proc { |a, b, c| a && (b || c) },
                    checkers: uk_postcode_checkers
end
```
where `uk_postcode_checkers` is method which returns hash with configurations  
https://github.com/azazelo/postcode_checker/blob/master/app/models/concerns/u_k_postcode_checkers.rb  
then in your controller:  
```ruby
class ChecksController < ApplicationController
  def checking
    @check = Check.new
  end

  def perform
    @check = Check.new(value: check_params[:string])
    message, alert_class =
      if @check.valid?
        @check.perform_check
        [@check.messages.join('<br/>'), _alert_class(@check.allowed)]
      else
        [@check.errors.full_messages.join('<br/>'), _alert_class(false)]
      end
    redirect_to checking_path, flash: { now: message, alert_class: alert_class }
  end

  private

  def _alert_class(cond)
    cond ? 'success' : 'danger'
  end

  def check_params
    params.permit(:string)
  end
end
```
for more detailed example see application   
in https://github.com/azazelo/postcode_checker

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'checkability'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install checkability
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Future works

- [ ] Use ChainOfResponsibility pattern to simplify call of checkers