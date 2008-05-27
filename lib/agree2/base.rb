require 'set'
#require 'activesupport/core_ext/class/inheritable_attributes'
module Agree2
  class Base
    class<<self
      
      def attr_serializable(*attributes)
        write_inheritable_attribute("serializable_attributes", 
          Set.new(attributes.map{|a|a.to_sym}) + 
          (serializable_attributes || []))
        attr_accessor *attributes
      end

      # Returns an array of all the attributes that have been made accessible to mass-assignment.
      def serializable_attributes # :nodoc:
        read_inheritable_attribute("serializable_attributes")
      end
      
    end

    attr_accessor :user,:attributes
        
    def initialize(user,fields={})
      @user=user
      attributes={}
      load_attributes(fields)
    end
    
    def decode(element)
        for field in self.class.serializable_attributes
          method_name="#{field.to_s}=".to_sym
          self.send(method_name, (element/field.to_sym).innerHTML) if self.respond_to?(method_name)
        end
        self
    end
    
#    def respond_to?(method, include_priv = false)
#      method_name = method.to_s
#      if attributes.nil?
#        return super
#      elsif attributes.has_key?(method_name)
#        return true 
#      elsif ['?','='].include?(method_name.last) && attributes.has_key?(method_name.first(-1))
#        return true
#      end
#      # super must be called at the end of the method, because the inherited respond_to?
#      # would return true for generated readers, even if the attribute wasn't present
#      super
#    end
#    
    protected
    
    def load_attributes(attributes)
      attributes.each_pair do |key,value|
        method_name="#{key.to_s}=".to_sym
        self.send(method_name,value) if self.respond_to?(method_name)
      end
      
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