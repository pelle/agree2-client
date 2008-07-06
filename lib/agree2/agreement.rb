module Agree2
  class Agreement<Base
    attr_serializable :permalink,:title,:body,:created_at,:updated_at,:fields
    
    def to_param
      permalink
    end
  end
end