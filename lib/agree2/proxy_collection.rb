require 'json'
module Agree2
  class ProxyCollection
    alias_method :proxy_respond_to?, :respond_to?
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
    
    def find(id)
      @klass.get @container,id
    end
    
    def respond_to?(symbol, include_priv = false)
      proxy_respond_to?(symbol, include_priv) || (load_target && @target.respond_to?(symbol, include_priv))
    end
    
    # Explicitly proxy === because the instance method removal above
    # doesn't catch it.
    def ===(other)
      load_target
      other === @target
    end
    
    protected
    
    def parse_json(json)
      instantiate_items(JSON.parse(json))
    end
    
    def instantiate_items(list=[])
      list.collect{|e|instantiate_item(e)}
    end
    
    def instantiate_item(attributes={})
      @klass.new @container,attributes
    end
        
    def load_target
      @target||=parse_json(@user.get("#{self.path}.json"))
    end
    
    def reset
      @target=nil
    end
    
    def method_missing(method, *args, &block)
      if load_target
        @target.send(method, *args, &block)
      end
    end
    
  end
end