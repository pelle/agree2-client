require File.join(File.dirname(__FILE__),"spec_helper")

describe Agree2::ProxyCollection do
  
  before(:each) do
    @user=mock("user")
    @user.stub!(:token).and_return("token")
    
    @agreements=Agree2::ProxyCollection.new(@user,"agreements")    
    @xml="<agreements><agreement><permalink>hello</permalink><title>My Title</title><body>My Body</body></agreement></agreements>"    
    @response={}
    @response.stub!(:body).and_return(@xml)
    @user.token.stub!(:get).with("/agreements.xml").and_return(@response)
  end
  
  it "should call web service" do
    @user.token.should_receive(:get).with("/agreements.xml").and_return(@response)
    @agreements.length.should==1
  end
  
  it "should have a user" do
    @agreements.user.should==@user
  end
  
  
end