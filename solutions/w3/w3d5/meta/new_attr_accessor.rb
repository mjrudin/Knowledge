class Object
  def new_attr_accessor(*attr_names)
    attr_names.each do |attr_name|
      define_method(attr_name) do
        instance_variable_get("@#{attr_name}")
      end

      define_method("#{attr_name}=") do |value|
        instance_variable_set("@#{attr_name}", value)
      end
    end
  end
end

class Cat
  new_attr_accessor :name, :color
end

cat = Cat.new
cat.name = 'Sally'
raise unless cat.name == 'Sally'
cat.color = 'brown'
raise unless cat.color == 'brown'
