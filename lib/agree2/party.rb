module Agree2
  class Party<Base
    attr_serializable :id,:role,:email,:first_name,:last_name,:created_at,:updated_at,:organization_name
    alias_method :agreement,:container  
  end
end