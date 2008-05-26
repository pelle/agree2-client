module Agree2
  class User
    attr_accessor :token,:client
    
    def initialize(client,key,secret)
      @client=client
      @token=OAuth::AccessToken.new @client.consumer,key,secret
    end
    
    def key
      @token.token
    end
    
    def secret
      @token.secret
    end
  end
end