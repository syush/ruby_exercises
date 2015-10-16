require_relative 'validate'

class TestValidate

  include Validate
   
  validate :foo, :presence
  validate :bar, :type, String
  validate :baz, :format, '\A\d{3}\z'

  attr_accessor :foo, :bar, :baz

end
