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

    def to_param
      permalink
    end
  end
end