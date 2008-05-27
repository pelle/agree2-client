module Agree2
  class User
    attr_accessor :token,:client
    
    def initialize(client,key,secret)
      @client=client
      @token=OAuth::AccessToken.new @client.consumer,key,secret
    end
    
    def agreements
      @agreements||=Agree2::ProxyCollection.new self,:agreements
    end
    
    def templates
      @templates||=Agree2::ProxyCollection.new self,:masters,'Template'
    end
    
    # OAuth Stuff below here
    
    # The AccessToken token
    def key
      @token.token
    end
    
    # The AccessToken secret
    def secret
      @token.secret
    end
  end
end