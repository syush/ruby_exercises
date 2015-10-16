require_relative 'exceptions'

module Validate

  @@list_of_checks = []
 
  def self.included(base)
    base.extend(ClassMethods)
  end 

  module ClassMethods

    attr_reader :list_of_checks
   
    def validate(name, check_type, *args)
      var_name = "@#{name}"
      method_name = "validate_#{name}_#{check_type}" 
      define_method(method_name) do
        value = instance_variable_get(var_name)
        case check_type.to_sym
        when :presence
          fail ProtectionError, "Instance var #{name} doesn't exist" if [nil, ""].include?(value)
        when :format
          if value && (value !~ /#{args[0]}/)
            fail ProtectionError, "Instance var #{name} doesn't match format"
          end
        when :type
          if value && !(value.is_a?(args[0]))
            fail ProtectionError, "Instance var #{name} isn't of type #{args[0]}"
          end
        end
      end
      @list_of_checks ? @list_of_checks << method_name.to_sym : @list_of_checks = []
    end

  end

  def validate!
    self.class.list_of_checks.each { |check| method(check).call }
  end

  def valid?
    begin
      validate!
      true
    rescue ProtectionError
      false
    end 
  end

end

