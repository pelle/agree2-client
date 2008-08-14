require File.join(File.dirname(__FILE__),"spec_helper")

describe Agree2::ProxyCollection do
  
  before(:each) do
    @client=Agree2::Client.new "client_key","client_secret"
    @user=Agree2::User.new(@client,"token","token_secret")
  end
  describe "load" do
    before(:each) do
      @agreements=Agree2::ProxyCollection.new(@user,"/agreements")
      @json="[#{IO.read(File.join(File.dirname(__FILE__),"fixtures","agreement.json"))}]"
      @user.stub!(:get).and_return(@json)
    end
    
    it "should have a path" do
      @agreements.path.should=="/agreements"
    end
    
    it "should have singular" do
      @agreements.singular.should=='Agreement'
    end

    it "should call web service" do
      @user.should_receive(:get).with("/agreements.json").and_return(@json)
      @agreements.length.should==1
    end

    it "should have a user" do
      @agreements.user.should==@user
    end
  end
  
  describe "with default value" do
    before(:each) do
      @agreements=Agree2::ProxyCollection.new(@user,"/agreements",nil,[{:permalink=>'hello'}])
    end
    
    it "should have a path" do
      @agreements.path.should=="/agreements"
    end
    
    it "should have singular" do
      @agreements.singular.should=='Agreement'
    end

    it "should have a user" do
      @agreements.user.should==@user
    end
    
    it "should have one item" do
      @agreements.length.should==1
    end
    
    it "should not call web service" do
      @user.should_not_receive(:get)
      @agreements.first      
    end
    
    it "should find an individual resource" do
      @user.should_receive(:get).with('/agreements/something.json').and_return(
                      IO.read(File.join(File.dirname(__FILE__),"fixtures","agreement.json")))
      @agreements.find('something')
    end
  end
  
  describe "nested load" do
    before(:each) do
      @agreement=Agree2::Agreement.new(@user,{:permalink=>'hello'})
      @parties=@agreement.parties
      @json="[#{IO.read(File.join(File.dirname(__FILE__),"fixtures","party.json"))}]"
      @user.stub!(:get).and_return(@json)
    end
    
    it "should have a path" do
      @parties.path.should=="/agreements/hello/parties"
    end
    
    it "should have singular" do
      @parties.singular.should=='Party'
    end

    it "should call web service" do
      @user.should_receive(:get).with("/agreements/hello/parties.json").and_return(@json)
      @parties.length.should==1
    end

    it "should have a user" do
      @parties.user.should==@user
    end
    
    it "should find an individual resource" do
      @user.should_receive(:get).with('/agreements/hello/parties/123.json').and_return(
                      IO.read(File.join(File.dirname(__FILE__),"fixtures","party.json")))
      @parties.find(123)
    end
    
  end
end