require 'json'
module Agree2
  class ProxyCollection
    alias_method :proxy_respond_to?, :respond_to? #:nodoc:
    instance_methods.each { |m| undef_method m unless m =~ /(^__|^nil\?$|^send$|proxy_)/ }
    attr_accessor :user,:path,:singular
    def initialize(container,path,class_name=nil,values=nil)
      @container=container
      @user=(container.is_a?(User) ? container : container.user)
      @path=path
      path=~/(\w+)$/
      @singular=(class_name||$1.singularize).downcase.classify
      @klass=eval "Agree2::#{@singular}"
      if values
        @target=instantiate_items(values)
      else
        reset
      end
    end
    
    # Builds an instance of the record
    def build(attributes={})
      @klass.new @container,attributes
    end
    
    # Builds and saves and instance of the record
    def create(attributes={})
      build(attributes).save
    end
    
    # Finds the instance given the id
    def find(id)
      @klass.get @container,id
    end
    
    def respond_to?(symbol, include_priv = false) #:nodoc:
      proxy_respond_to?(symbol, include_priv) || (load_target && @target.respond_to?(symbol, include_priv))
    end
    
    # Explicitly proxy === because the instance method removal above
    # doesn't catch it.
    def ===(other) #:nodoc:
      load_target
      other === @target
    end
    
    protected
    
    def parse_json(json) #:nodoc:
      instantiate_items(JSON.parse(json))
    end
    
    def instantiate_items(list=[]) #:nodoc:
      list.collect{|e|instantiate_item(e)}
    end
    
    def instantiate_item(attributes={}) #:nodoc:
      @klass.new @container,attributes
    end
        
    def load_target #:nodoc:
      @target||=parse_json(@user.get("#{self.path}"))
    end
    
    def reset #:nodoc:
      @target=nil
    end
    
    def method_missing(method, *args, &block) #:nodoc:
      if load_target
        @target.send(method, *args, &block)
      end
    end
    
  end
end