class AttrAccessorObject
  def self.my_attr_accessor(*names)

      # These two are considered bad form as they force you to do a 1-liner
      # they work by evaluation the string within the class object they are
      # called on
      #
      # self.class_eval("def #{name};@#{name};end")
      # self.class_eval("def #{name};@#{name};end")
      #
    names.each do |name|
      
      self.define_method(name) do
        get_instance_variable("@#{name}")
      end
      
      self.define_method(name + "=") do |val|
        set_instance_variable("@#{name}", val)
      end
    end    
  end
end
