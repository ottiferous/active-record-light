require_relative 'db_connection'
require_relative '01_mass_object'
require 'active_support/inflector'

class MassObject
  def self.parse_all(results)
    
    object_array = []
    results.each do |object_hash|
      object_hash.each do |key, value| 
        p "#{key} => #{value}"
        new_class.send(:define_method, key) do
          get_instance_variable("@#{key}")
        end
        
        new_class.send(:define_method, (key.to_s + "=")) do
          set_instance_variable("@#{key}", value )
        end
      end
        p "class.name -- #{new_class.name}"
        # p "class.owner_id -- #{new_class.owner_id}"
      
      object_array << new_class
    end
    
    object_array
  end  
end

class Cat < SQLObject
end

Cat.parse_all([{:name => "Haskell", :owner_id => 1}])

class SQLObject < MassObject
  def self.columns
    # ...
  end

  def self.table_name=(table_name)
    @table_name ||= table_name.pluralize
  end

  def self.table_name
    @table_name || self.to_s.downcase.pluralize
  end

  def self.all
    # ...
  end

  def self.find(id)
    # ...
  end

  def attributes
    # ...
  end

  def insert
    # ...
  end

  def initialize
    # ...
  end

  def save
    # ...
  end

  def update
    # ...
  end

  def attribute_values
    # ...
  end
end
