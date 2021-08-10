class Person
  def initialize(name)
    @name = name
  end

  def self.attr_get(f)
    define_method(f.to_s.upcase) do
      instance_variable_get("@#{f}")
    end
  end

  attr_get :name
end

p = Person.new('cll')
p p.NAME
