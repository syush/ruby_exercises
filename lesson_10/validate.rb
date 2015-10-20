require_relative 'exceptions'

module Validate

  @@list_of_checks = []
 
  def self.included(base)
    base.extend(ClassMethods)
  end 

  module ClassMethods

    def list_of_checks
      @list_of_checks || []
    end
   
    def validate(name, type_of_check, *args)
      var_name = "@#{name}"
      method_name = "validate_#{name}_#{type_of_check}" 
      define_method(method_name) do
        value = instance_variable_get(var_name)
        arg = false || args[0]
        check_method_name = "check_#{type_of_check.to_s}".to_sym
        send check_method_name, name, value, arg
      end
      if @list_of_checks 
        @list_of_checks << method_name.to_sym 
      else
        @list_of_checks = [method_name.to_sym]
      end
    end

  end

  def valid?
    begin
      validate!
      true
    rescue ProtectionError
      false
    end 
  end

  private

  def validate!
    [self.class, self.class.superclass].each do |cl|
      if defined?(cl.list_of_checks)
        cl.list_of_checks.each { |check| method(check).call }
      end
    end
  end

  def check_presence(name, value, _arg)
    if [nil, ""].include?(value)
      fail ProtectionError, "Instance var @#{name} of class #{self.class} doesn't exist"
    end
  end

  def check_format(name, value, regex)
    if value && (value !~ regex)
      fail ProtectionError, "Instance var @#{name} of class #{self.class} "\
                            "doesn't match format"
    end
  end

  def check_type(name, value, golden_type)
    if value && !(value.is_a?(golden_type))
      fail ProtectionError, "Instance var @#{name} of class #{self.class} "\
                            "isn't of type #{golden_type}"
    end
  end

  def check_equal(name, value, golden_value)
    unless value == golden_value
      fail ProtectionError, "Instance var @#{name} of class #{self.class} "\
                            "doesn't equal #{golden_value}"
    end
  end

  def check_range(name, value, bounds)
    unless value.between?(bounds)
      fail ProtectionError, "Instance var #{name} of class #{self.class} "\
                            "is out of range #{bounds}"
    end
  end

  def check_greater(name, value, bound)
    unless value > bound
      fail ProtectionError, "Instance var @#{name} of class #{self.class} "\
                            "is not greater than #{bound}"
    end
  end

  def check_greater_or_equal(name, value, bound)
    unless value >= bound
      fail ProtectionError, "Instance var @#{name} of class #{self.class}"\
                            " is not greater-or-equal than #{bound}"
    end
  end

  def check_each_type(name, value, type)
    value.each do |v|
      unless v.is_a?(type)
        fail ProtectionError, "Element of instance var array @#{name}"\
                              " of class #{self.class} is not #{args[0]}"
      end
    end
  end

  def check_each_valid(name, value, _arg)
    value.each do |v|
      unless v.valid?
        fail ProtectionError, "Element of instance var array @#{name}"\
                              " of class #{self.class} is not valid"
      end
    end
  end

  def check_unique_elements(name, value, _arg)
    unless value.size == value.uniq.size
      fail ProtectionError, "Array @#{name} of class #{self.class} has duplicates"
    end
  end

  def check_user_checker(name, value, checker_method)
    unless self.class.method(checker_method).call(value)
      fail ProtectionError, "User check #{checker_method} failed on instance var @#{name}"\
                            " of class #{self.class}"
    end
  end
 
  def check_unique_object(name, value, find_method)
    if self.class.method(find_method).call(value)
      fail ProtectionError, "Another object of class #{self.class} or parent"\
                            "with instance var @#{name} equal to #{value} already exists"
    end
  end

end

