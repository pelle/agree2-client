require File.join(File.dirname(__FILE__),"spec_helper")

describe Agree2::User do
  
  before(:each) do
    @client=Agree2::Client.new "client_key","client_secret"
    @user=Agree2::User.new(@client,"token","token_secret")
  end
    
  it "should create user" do
    @user.client.should==@client
    @user.token.consumer.should==@client.consumer
    @user.key.should=="token"
    @user.secret.should=="token_secret"
  end
  
end