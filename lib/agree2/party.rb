module Agree2
  class Party<Base
    attr_serializable :id,:role,:email,:first_name,:last_name,:created_at,:updated_at,:organization_name
    alias_method :agreement,:container  
    

    def self.validate_parties_hash(parties)  #:nodoc:
      parties&&parties.each{|r,p| validate_party_hash(p)}
      true
    end
    
    def self.validate_party_hash(p)  #:nodoc:
      raise ArgumentError,"Your parties are missing required fields" if [:first_name,:last_name,:email].find{|k| !p.include?(k)}
      return true
    end
  end
end