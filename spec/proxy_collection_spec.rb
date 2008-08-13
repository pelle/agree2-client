require File.join(File.dirname(__FILE__),"spec_helper")

describe Agree2::ProxyCollection do
  
  before(:each) do
    @client=Agree2::Client.new "client_key","client_secret"
    @user=Agree2::User.new(@client,"token","token_secret")
    @agreements=Agree2::ProxyCollection.new(@user,"agreements")    
    @xml="<agreements><agreement><permalink>hello</permalink><title>My Title</title><body>My Body</body></agreement></agreements>"    
    @user.stub!(:get).and_return(@xml)
  end
  
  it "should call web service" do
    @user.should_receive(:get).with("agreements.xml").and_return(@xml)
    @agreements.length.should==1
  end
  
  it "should have a user" do
    @agreements.user.should==@user
  end
  
end