module Agree2
  class Template<Agreement
    
    def self.collection_name
      "masters"
    end
    def self.singular_name
      "agreement"
    end
    
    def prepare(fields={},parties={},application_role=nil)
      parties[application_role]=:application if application_role
      raw_prepare(:fields=>fields,:parties=>parties)
    end
    
    def prepare_and_sign(fields={},parties={},application_role='application')
      parties[application_role]=:application
      raw_prepare(:fields=>fields,:parties=>parties,:sign=>application_role)
    end
    
    protected

    def raw_prepare(params={})
      user.post("/masters/#{permalink}/prepare",params)
    end
  end
end