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
   
    def validate(name, check_type, *args)
      var_name = "@#{name}"
      method_name = "validate_#{name}_#{check_type}" 
      define_method(method_name) do
        value = instance_variable_get(var_name)
        case check_type.to_sym
        when :presence
          if [nil, ""].include?(value)
            fail ProtectionError, "Instance var @#{name} of class #{self.class} doesn't exist"
          end
        when :format
          if value && (value !~ args[0])
            fail ProtectionError, "Instance var @#{name} of class #{self.class} "\
                                  "doesn't match format"
          end
        when :type
          if value && !(value.is_a?(args[0]))
            fail ProtectionError, "Instance var @#{name} of class #{self.class} "\
                                  "isn't of type #{args[0]}"
          end
        when :equal
          unless value == args[0]
            fail ProtectionError, "Instance var @#{name} of class #{self.class} "\
                                  "doesn't equal #{args[0]}"
          end
        when :range
          unless value.between?(args[0])
            fail ProtectionError, "Instance var #{name} of class #{self.class} "\
                                  "is out of range #{args[0]}"
          end
        when :greater
          unless value > args[0]
            fail ProtectionError, "Instance var @#{name} of class #{self.class} "\
                                  "is not greater than #{args[0]}"
          end
        when :greater_or_equal
          unless value >= args[0]
            fail ProtectionError, "Instance var @#{name} of class #{self.class}"\
                                  " is not greater-or-equal than #{args[0]}"
          end
        when :each_type
          value.each do |v|
            unless v.is_a(args[0])
              fail ProtectionError, "Element of instance var array @#{name}"\
                                    " of class #{self.class} is not #{args[0]}"
            end
          end
        when :each_valid
          value.each do |v|
            unless v.valid?
              fail ProtectionError, "Element of instance var array @#{name}"\
                                    " of class #{self.class} is not valid"
            end
          end
        when :unique_elements
          unless value.size == value.uniq.size
            fail ProtectionError, "Array @#{name} of class #{self.class} has duplicates"
          end
        when :user_checker
          unless self.class.method(args[0]).call(value)
            fail ProtectionError, "User check #{args[0]} failed on instance var @#{name}"\
                                  " of class #{self.class}"
          end
        when :unique_object
          if self.class.method(args[0]).call(value)
            fail ProtectionError, "Another object of class #{self.class} or parent"\
                                  "with instance var @#{name} equal to #{value} already exists"
          end
        end
      end
      @list_of_checks ? @list_of_checks << method_name.to_sym : @list_of_checks = []
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

end

