module InstanceCounter

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def instances
      @instance_counter ||= 0
      @instance_counter
    end

    def increase_counter
      @instance_counter = @instance_counter ? @instance_counter + 1 : 1
    end
  end

  private

  def register_instance
    done = false
    cl = self.class
    until done do
      if defined?(cl.increase_counter)
        cl.increase_counter
        cl = cl.superclass
      else
        done = true
      end
    end
  end

end

