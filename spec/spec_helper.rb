require 'coveralls'
Coveralls.wear!('rails')

require 'rspec'
require 'parse_name_from_email'

RSpec.configure do |c|
  c.order = 'random'
  c.color = true
end
