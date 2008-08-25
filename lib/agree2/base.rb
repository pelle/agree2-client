require 'json'
require 'set'
module Agree2
  # The superclass of all Agree2 Resource objects.
  class Base
    class<<self
      
      def attr_serializable(*attributes) #:nodoc:
        attributes.map!{|a|a.to_sym}
        write_inheritable_attribute("serializable_attributes", 
          Set.new(attributes) + 
          (serializable_attributes || []))
        attr_accessor *attributes
      end

      # Returns an array of all the attributes that have been made accessible to mass-assignment.
      def serializable_attributes # :nodoc:
        read_inheritable_attribute("serializable_attributes")
      end
      
      def collection_path #:nodoc:
        "/#{collection_name}"
      end

      def instance_path(id) #:nodoc:
        "#{collection_path}/#{id}"
      end

      def collection_name #:nodoc:
        self.to_s.demodulize.tableize
      end

      def singular_name #:nodoc:
        self.to_s.demodulize.underscore.singularize
      end
      
      # Gets an instance of a resource
      def get(container,id)
        user=(container.is_a?(User) ? container : container.user)
        new( container, user.get(container.path+instance_path(id)))
      end
      
    end

    attr_accessor :user,:container
        
    def initialize(container,fields={})#:nodoc:
      @container=container
      @user=(container.is_a?(User) ? container : container.user)
      if fields.is_a?(Hash)
        load_attributes(fields)
      else
        load_json(fields)
      end
    end
    
    # Has this record been saved to the server yet?
    def new_record?
      @from_wire!=true
    end
    
    # Reloads the object from Agree2's servers
    def reload
      load_json(user.get(path))
    end

    # Destroys the object from Agree2's servers
    def destroy
      user.delete(path)
    end
    
    # Returns the full URL for the object
    def to_url
      "#{AGREE2_URL}#{path}"
    end
    
    # Returns the relative path to the object
    def path #:nodoc:
      self.container.path+self.class.instance_path(to_param)
    end
    
    # The primary key of the object
    def to_param #:nodoc:
      id
    end
    
    # Saves the record to the server
    def save
      if new_record?
        load_json(@user.post("#{self.container.path}/#{self.class.collection_name}",attributes_for_save))
      else
        load_json(@user.put("#{path}",attributes_for_save))
      end
    end
    
    # Get the primary attributes of an object as a hash
    def attributes
      self.class.serializable_attributes.inject({}) do |h,field|
        value=self.send(field)
        h[field]=value if value
        h
      end
    end
    
    protected
    
    def attributes_for_save #:nodoc:
      {self.class.singular_name=>attributes}
    end
    
    def decode(element) #:nodoc:
        for field in self.class.serializable_attributes
          method_name="#{field.to_s}=".to_sym
          self.send(method_name, (element/field.to_sym).innerHTML) if self.respond_to?(method_name)
        end
        self
    end

    def load_attributes(attributes) #:nodoc:
      @attributes=attributes
      attributes.each_pair do |key,value|
        method_name="#{key.to_s}=".to_sym
        self.send(method_name,value) if self.respond_to?(method_name)
      end
    end
        
    def load_json(json) #:nodoc:
      @from_wire=true
      load_attributes(JSON.parse(json))
    end
#    private
#    
#    def method_missing(method_symbol, *arguments) #:nodoc:
#      method_name = method_symbol.to_s
#
#      case method_name.last
#        when "="
#          self.attributes[method_name.first(-1)] = arguments.first
#        when "?"
#          self.attributes[method_name.first(-1)]
#        else
#          self.attributes.has_key?(method_name) ? self.attributes[method_name] : super
#      end
#    end
#    
  end
end