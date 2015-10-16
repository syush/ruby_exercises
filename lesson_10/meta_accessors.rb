module MetaAccessors

  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = name_to_var(name)
      history_name = "#{name}_history"
      history_var_name = name_to_var(history_name)
      simple_getter(name)
      define_method("#{name}=") do |value|
        new_history = ((send history_name.to_sym) || []) << value
        instance_variable_set(var_name, value)
        instance_variable_set(history_var_name, new_history)
      end
      simple_getter(history_name)
    end
  end

  def strong_attr_accessor(name, class_name)
    simple_getter(name)
    complex_setter(name) do |value|
      fail "Assigned value is not a #{class_name}" unless value.is_a?(class_name)
    end
  end

  private

  def name_to_var(name)
    "@#{name}".to_sym
  end

  def simple_getter(name)
    var_name = name_to_var(name)
    define_method(name) { instance_variable_get(var_name) }
  end

  def complex_setter(name)
    var_name = name_to_var(name)
    define_method("#{name}=") do |value|
      yield(value)
      instance_variable_set(var_name, value)
    end
  end

end

