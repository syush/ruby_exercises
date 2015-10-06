module InstanceCounter

@instance_counter = 0

def instances
  if !@instance_counter
    @instance_counter = 0
  end
  @instance_counter
end

def increase_counter
  if !@instance_counter
    @instance_counter = 1 
  else
    @instance_counter += 1
  end
end

def register_instance
  self.class.increase_counter
end

end
