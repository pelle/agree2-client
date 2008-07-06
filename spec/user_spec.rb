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
  
  it "should find all agreements" do
    @agreements=[]
    @xml="XML"
    @user.should_receive(:get).with("/agreements.xml").and_return(@xml)
    @user.agreements.should_receive(:parse_xml).with(@xml).and_return(@agreements)
    @user.agreements.length.should==0
    @user.agreements.should==@agreements
  end
  
end