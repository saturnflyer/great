require 'simplecov'

SimpleCov.start do
  add_filter "great/version"
end

require 'great'
require 'minitest/autorun'
