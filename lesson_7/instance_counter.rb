module InstanceCounter

def instances
  @instance_counter = 0 if !@instance_counter
  @instance_counter
end

def increase_counter
  @instance_counter = @instance_counter ? @instance_counter + 1 : 1 
end

def register_instance
  self.class.increase_counter
end

end
