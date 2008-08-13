module Agree2
  class Agreement<Base
    attr_serializable :permalink,:title,:body,:created_at,:updated_at,:fields,:state,:active_version,
                      :version,:digest,:finalized_at,:finalized_at,:terminated_at,:activated_at,:valid_to
    
    def parties
      @templates||=Agree2::ProxyCollection.new self,"#{self.path}/parties",'Party'
    end

    def to_param
      permalink
    end
  end
end