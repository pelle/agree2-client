module Agree2
  class User
    attr_accessor :token,:client
    
    def initialize(client,key,secret)
      @client=client
      @token=OAuth::AccessToken.new @client.consumer,key,secret
    end
    
    def agreements
      @agreements||=Agree2::ProxyCollection.new self,'/agreements','Agreement'
    end
    
    def templates
      @templates||=Agree2::ProxyCollection.new self,'/masters','Template'
    end
    
    def get(path)
      handle_response token.get(path)
    end

    def head(path)
      handle_response token.head(path)
    end
    
    def post(path,data)
      handle_response token.post(path,data.to_json,{'Content-Type'=>'application/json'})
    end
    
    def put(path,data)
      handle_response token.put(path,data)
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
    
    def path
      ""
    end
    protected
    
    def handle_response(response)
      case response.code
      when "200"
        response.body
      when "302"
        if response['Location']=~/(#{AGREE2_URL})\/(.*)$/
          parts=$2.split('/')
          puts parts.inspect
          (parts[0].classify.constantize).get self,parts[1]
        else
          #todo raise hell
        end
      else
        response
      end
    end
  end
end