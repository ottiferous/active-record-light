require_relative 'db_connection'
require_relative '01_mass_object'
require 'active_support/inflector'

class MassObject
  # Cat.parse_all([{:name => "Haskell", :owner_id => 1}])
  def self.parse_all(results)
    results.each do |hash_object|           # e.g. {:name=>"cat1", :owner_id=>1}
      new_obj = self.new(hash_object)
    end
  end
end

class SQLObject < MassObject
  def self.columns
    query = "SELECT * FROM #{self.table_name}"
    columns = (DBConnection.instance.execute2 query)[0]
    
    columns.map do |name|
      define_method(name) { self.attributes[name] }
      define_method("#{name}=") { |val| self.attributes[name] = val }
    end
    columns.map(&:to_sym)
  end

  def self.table_name=(table_name)
    @table_name ||= table_name.downcase.underscore.pluralize
  end

  def self.table_name
    @table_name || self.to_s.downcase.underscore.pluralize
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
    DBConnection.instance.execute2(<<-SQL)
    INSERT INTO
    #{@table_name}
    VALUES
      
    SQL
  end

  def initialize(params = {})
    # {:name=>"cat1", :owner_id=>1}
    params.each do |attr_name, value|
      if self.class.columns.include? attr_name
         self.send(attr_name, value)
      else
        raise "unknown attribute '#{attr_name}'"
      end
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
