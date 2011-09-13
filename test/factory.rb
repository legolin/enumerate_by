module Factory
  # Build actions for the model
  def self.build(model, &block)
    name = model.to_s.underscore
    
    define_method("#{name}_attributes", block)
    define_method("valid_#{name}_attributes") {|*args| valid_attributes_for(model, *args)}
    define_method("new_#{name}")              {|*args| new_record(model, *args)}
    define_method("create_#{name}")           {|*args| create_record(model, *args)}
  end
  
  # Get valid attributes for the model
  def valid_attributes_for(model, attributes = {})
    name = model.to_s.underscore
    send("#{name}_attributes", attributes)
    attributes.stringify_keys!
    attributes
  end
  
  # Build an unsaved record
  def new_record(model, *args)
    attributes = valid_attributes_for(model, *args)
    record = model.new(attributes)
    attributes.each {|attr, value| record.send("#{attr}=", value) if model.accessible_attributes && !model.accessible_attributes.include?(attr) || model.protected_attributes && model.protected_attributes.include?(attr)}
    record
  end
  
  # Build and save/reload a record
  def create_record(model, *args)
    record = new_record(model, *args)
    record.save!
    record.reload
    record
  end
  
  build Car do |attributes|
    attributes.reverse_merge!(
      :name => 'Ford Mustang'
    )
  end
  
  build CarPart do |attributes|
    attributes.reverse_merge!(
      :number => 123321
    )
  end
  
  build Color do |attributes|
    attributes.reverse_merge!(
      :name => 'red'
    )
  end
  
  build LegacyColor do |attributes|
    attributes.reverse_merge!(
      :name => 'red'
    )
  end
  
  build Order do |attributes|
    attributes[:car_part] = create_car_part unless attributes.include?(:car_part)
    attributes.reverse_merge!(
      :state => 'pending'
    )
  end
  
 # build Tag do |attributes|
 #   attributes.reverse_merge!(
 #     :name => 'rails'
 #   )
 # end
end
