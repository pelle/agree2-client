require File.join(File.dirname(__FILE__),"spec_helper")

describe Agree2::User do
  
  before(:each) do
    @client=Agree2::Client.new "client_key","client_secret"
    @user=Agree2::User.new(@client,"token","token_secret")
  end
    
  it "should create user" do
    @user.client.should==@client
    @user.access_token.consumer.should==@client.consumer
    @user.token.should=="token"
    @user.secret.should=="token_secret"
  end
  
  it "should find all agreements" do
    @agreements=[]
    @json="[]"
    @user.should_receive(:get).with("/agreements.json").and_return(@json)
    @user.agreements.length.should==0
    @user.agreements.should==@agreements
  end
  
  it "should find all templates" do
    @templates=[]
    @json="[]"
    @user.should_receive(:get).with("/masters.json").and_return(@json)
    @user.templates.length.should==0
    @user.templates.should==@templates
  end
  
end