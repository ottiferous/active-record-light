require_relative 'db_connection'
require_relative '01_mass_object'
require 'active_support/inflector'

class MassObject
  def self.parse_all(results)
    results.each do |object|
      new_obj = self.new(object)
    end
  end
end

# Cat.parse_all([{:name => "Haskell", :owner_id => 1}])

class SQLObject < MassObject
  def self.columns
    query = "SELECT * FROM #{self.table_name}"
    columns = (DBConnection.instance.execute2 query)[0]
    
    #convert to symbols
    columns.map(&:to_sym).each do |attr_name|
      self.define_method(name) do
        @attributes[name]
      end
      self.define_method(name + "=") do |val|
        @attributes[name] = val
      end
    end      
    
  end

  def self.table_name=(table_name)
    @table_name ||= table_name.pluralize
  end

  def self.table_name
    @table_name || self.to_s.downcase.pluralize
  end

  def self.all
    data = DBConnection.instance.execute2(<<-SQL)
          SELECT
            *
          FROM
          #{@table_name}
        SQL
    self.parse_all(data)
  end

  def self.find(id)
    DBConnection.instance.execute2(<<-SQL)
    SELECT
      *
    FROM
      #{@table_name}
    WHERE
      id = #{id}
    SQL
  end

  def attributes
    @atrributes ||= {}
  end

  def insert
    # ...
  end

  def initialize(params= {})
    params.each do |attr_name, value|
      raise "unknown attribute '#{attr_name}'" unless self.class.columns.include? attr_name.pluralize
    end
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
