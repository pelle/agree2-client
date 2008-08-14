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
      
      def instance_url(id) #:nodoc:
        "/#{collection_name}/#{id}"
      end

      def collection_name #:nodoc:
        self.to_s.demodulize.tableize
      end
      
      # Gets an instance of a resource
      def get(container,id)
        user=(container.is_a?(User) ? container : container.user)
        new( container, user.get(container.path+instance_url(id)+".json"))
      end
      
    end

    attr_accessor :user,:attributes,:container
        
    def initialize(container,fields={})#:nodoc:
      @container=container
      @user=(container.is_a?(User) ? container : container.user)
      attributes={}
      if fields.is_a?(Hash)
        load_attributes(fields)
      else
        load_json(fields)
      end
    end
    
    # Reloads the object from Agree2's servers
    def reload
      load_json(user.get(path+".json"))
    end
    
    # Returns the full URL for the object
    def to_url
      "#{AGREE2_URL}#{path}"
    end
    
    # Returns the relative path to the object
    def path #:nodoc:
      self.container.path+self.class.instance_url(to_param)
    end
    
    # The primary key of the object
    def to_param #:nodoc:
      id
    end
    
    protected
    
    def decode(element) #:nodoc:
        for field in self.class.serializable_attributes
          method_name="#{field.to_s}=".to_sym
          self.send(method_name, (element/field.to_sym).innerHTML) if self.respond_to?(method_name)
        end
        self
    end

    def load_attributes(attributes) #:nodoc:
      attributes.each_pair do |key,value|
        method_name="#{key.to_s}=".to_sym
        self.send(method_name,value) if self.respond_to?(method_name)
      end
    end
        
    def load_json(json) #:nodoc:
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