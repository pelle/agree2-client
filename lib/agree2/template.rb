module Agree2
  # The Template allows you to create agreements based on a template. You can pick between existing community created templates or
  # create your own that fits your application.
  #
  # To review some of the public templates available go to: https://agree2.com/masters/public
  #
  # If you plan on creating and signing an agreement for your user to accept the process is like this:
  #
  # 1. Load your template
  # 2. Prepare and Sign the agreement, which fills out the template, invites your user and signs it on your behalf
  # 3. Redirect the User to Accept
  # 4. User Accepts agreement
  # 5. Agree2 optional calls an "endpoint" web service on your web service.
  # 6. User is redirected back to your application to a URL you designate
  #
  class Template<Agreement
    
    def self.collection_name  #:nodoc:
      "masters"
    end
        
    # Prepares a template and optionally invites parties.
    #
    # === optional fields
    #
    # <tt>fields</tt> - a hash of parameters to be used to fill out the template. eg:
    #
    #     {:amount=>100,:valid_to=>1.month.from_now,:service=>'Ruby Developer'}
    # 
    # <tt>parties</tt> - a hash of parties. The hash should follow this format:
    #
    #     { :client=>{:first_name=>'Bob',:last_name=>'Bryson',:email=>'bob@bob.inv',:organization_name=>'Big Client Inc'}}
    # 
    # The above adds a party with the role *client*. The first_name, last_name and email fields are all required.
    #
    # <tt>application_role</tt> if you would like to add your applications user as a party set this to the role that you want:
    #
    #     @template.prepare {},{},"broker"
    #
    # Adds your application as a party with the role broker.
    #
    # A typical example for a consulting agreement:
    #
    #     @template.prepare {:rate=>"140",:valid_to=>"1 month from today"},
    #                           {
    #                             :consultant=>{:first_name=>'Alice',:last_name=>'Springs',:email=>'alice@example.com'},
    #                             :client=>{:first_name=>'Bob',:last_name=>'Bryson',:email=>'bob@bob.inv',
    #                                       :organization_name=>'Big Client Inc'}
    #                           }
    #     }
    #
    def prepare(fields={},parties={},application_role=nil)
      Party.validate_parties_hash(parties)
      parties[application_role]=:application if application_role
      raw_prepare(:fields=>fields,:parties=>parties)
    end
    
    # Prepares a template, invites parties and signs it with your application
    #
    # === required fields
    #
    # <tt>fields</tt> - a hash of parameters to be used to fill out the template. eg:
    #
    #     {:amount=>100,:valid_to=>1.month.from_now,:service=>'Ruby Developer'}
    # 
    # <tt>parties</tt> - a hash of parties. The hash should follow this format:
    #
    #     { :client=>{:first_name=>'Bob',:last_name=>'Bryson',:email=>'bob@bob.inv',:organization_name=>'Big Client Inc'}}
    # 
    # The above adds a party with the role *client*. The first_name, last_name and email fields are all required.
    #
    # <tt>application_role</tt> if you would like to add your applications user as a party set this to the role that you want:
    #
    #     @template.prepare_and_sign {},{},"broker"
    #
    # Adds your application as a party with the role broker.
    #
    # A typical example for a user agreement:
    #
    #     @template.prepare_and_sign {:name=>"Alice Springs"},
    #                           {
    #                             :user=>{:first_name=>'Alice',:last_name=>'Springs',:email=>'alice@example.com'}
    #                           },'service'
    #     }
    #
    
    def prepare_and_sign(fields={},parties={},application_role='application')
      raise ArgumentError,"You need to add at least one party" if parties.empty?
      Party.validate_parties_hash(parties)
      parties[application_role]=:application
      raw_prepare(:fields=>fields,:parties=>parties,:sign=>application_role)
    end
    
    protected

    def raw_prepare(params={}) #:nodoc:
      Agreement.new @user, user.post("/masters/#{permalink}/prepare",params)
    end
  end
end