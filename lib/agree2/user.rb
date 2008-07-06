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
    
    def get(path)
      handle_response token.get(path)
    end

    def head(path)
      handle_response token.head(path)
    end
    
    def post(path,xml)
      handle_response token.post(path,xml)
    end
    
    def put(path,xml)
      handle_response token.put(path,xml)
    end
    
    def delete(path)
      handle_response token.delete(path)
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
    
    protected
    
    def handle_response(response)
      response.body
    end
  end
end