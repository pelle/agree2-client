require 'oauth/consumer'

module Agree2
  class Client
    attr_accessor :consumer
    
    def initialize(key,secret)
      @consumer=OAuth::Consumer.new(key,secret,{:site=>AGREE2_URL})
    end
    
    # initialize a new user object with the given token and secret. The user object is what you use to do most of the work.
    # Store the token and token_secret in your database to reuse    
    def user(token,token_secret)
      User.new(self,token,token_secret)
    end
    
    # Start the OAuth Request Token Dance
    def get_request_token
      consumer.get_request_token
    end
    
    # Exchange an Authorized RequestToken for a working user object
    def user_from_request_token(req)
      access_token=req.get_access_token
      user(access_token.token,access_token.secret)
    end

    def key
      consumer.key
    end
    
    def secret
      consumer.secret
    end
  end
end