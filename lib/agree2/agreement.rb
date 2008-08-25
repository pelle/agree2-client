module Agree2
  class Agreement<Base
    attr_serializable :permalink,:title,:body,:created_at,:updated_at,:smart_fields,:state,:active_version,
                      :version,:digest,:finalized_at,:finalized_at,:terminated_at,:activated_at,:valid_to
    
    alias_method :fields,:smart_fields
    # Returns the parties to the agreement
    def parties
      @parties||=Agree2::ProxyCollection.new self,"#{self.path}/parties",'Party'
    end
    
    def parties=(values)
      @parties=Agree2::ProxyCollection.new self,"#{self.path}/parties",'Party',values
    end

    def to_param #:nodoc:
      permalink
    end
    
    def respond_to?(symbol, include_priv = false)  #:nodoc:
      return true if super symbol,include_priv
      return false if fields.nil?||fields.empty?
      method=symbol.to_s
      if method=~/(.+)=$/
        field=$1
        setter=true
      else
        field=method
        setter=false
      end
      fields.has_key?(field)
    end
    
    # Finalize marks a draft agreement as being ready to accept
    def finalize!
      user.post(path+"/finalize")==" "
    end
    
    protected
    
    def attributes_for_save #:nodoc:
      if new_record?
        {self.class.singular_name=>attributes}
      else
        {"fields"=>fields}
      end
    end
    
    def method_missing(method, *args, &block)  #:nodoc:
      return super(method, *args, &block) if fields.nil?||fields.empty?
      method=method.to_s
      if method=~/(.+)=$/
        field=$1
        setter=true
      else
        field=method
        setter=false
      end
      if fields.has_key?(field)
        if setter
          fields[field]=args.first
        else
          fields[field]
        end
      else
        super method, *args, &block
      end
    end
    
  end
end