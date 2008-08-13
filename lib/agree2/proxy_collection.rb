require 'hpricot'
module Agree2
  class ProxyCollection
    alias_method :proxy_respond_to?, :respond_to?
    instance_methods.each { |m| undef_method m unless m =~ /(^__|^nil\?$|^send$|proxy_)/ }
    attr_accessor :user,:path,:singular
    def initialize(container,path,class_name=nil)
      @container=container
      @user=(container.is_a?(User) ? container : container.user)
      @path=path.to_s
      @singular=(class_name||@path.singularize).downcase.to_sym
      @klass=eval "Agree2::#{(class_name||@path).to_s.classify}"
      reset
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
    
    def parse_xml(xml)
      target=[]
      doc=Hpricot.parse(xml)
      (doc/@singular).each do |element|
        target<<instantiate_item().decode(element)
      end
      target
    end
    
    def instantiate_item(attributes={})
      @klass.new @container,attributes
    end
    
    def path
      @path
    end
    
    def load_target
      @target||=parse_xml(@user.get("#{self.path}.xml"))
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