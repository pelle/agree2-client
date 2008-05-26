require File.join(File.dirname(__FILE__),"spec_helper")

describe Agree2::Client do
  
  before(:each) do
    @client=Agree2::Client.new "client_key","client_secret"
  end
  
  it "should contain key and secret" do
    @client.key.should=="client_key"
    @client.secret.should=="client_secret"
  end
  
  it "should have consumer" do
    consumer=@client.consumer
    consumer.key.should==@client.key
    consumer.secret.should==@client.secret
    consumer.site.should=="https://agree2.com"
  end
  
  it "should create user" do
    user=@client.user("token","token_secret")
    user.client.should==@client
    user.token.consumer.should==@client.consumer
    user.key.should=="token"
    user.secret.should=="token_secret"
  end
  
  it "should create request token" do
    request_token=mock("access_token")
    @client.consumer.should_receive(:get_request_token).and_return(request_token)
    token=@client.get_request_token
    token.should==request_token
  end

  it "should create request token" do
    request_token=mock("request_token")
    access_token=mock("access_token")
    access_token.stub!(:token).and_return('token')
    access_token.stub!(:secret).and_return('token_secret')
    request_token.should_receive(:get_access_token).and_return(access_token)
    user=@client.user_from_request_token(request_token)
    user.client.should==@client
    user.token.consumer.should==@client.consumer
    user.key.should=="token"
    user.secret.should=="token_secret"
  end

end