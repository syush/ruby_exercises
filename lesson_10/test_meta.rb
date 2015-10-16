require_relative 'meta_accessors'

class TestMeta
  extend MetaAccessors

  attr_accessor_with_history :test, :foo

  strong_attr_accessor :bar, Fixnum
  
end
