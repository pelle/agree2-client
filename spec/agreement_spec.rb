require File.join(File.dirname(__FILE__),"spec_helper")
describe Agree2::Agreement do
  before(:each) do
    @client=Agree2::Client.new "client_key","client_secret"
    @user=Agree2::User.new(@client,"token","token_secret")
    @json=IO.read(File.join(File.dirname(__FILE__),"fixtures","agreement.json"))
  end
  
  describe "Built from hash" do
    before(:each) do
      @agreement=Agree2::Agreement.new(@user,{:title=>"My Title",:body=>"My Body"})
    end
  
    it "should have a user" do
      @agreement.user.should==@user
    end
  
    it "should have title" do 
      @agreement.title.should=="My Title"
    end
  
    it "should have body" do
      @agreement.body.should=="My Body"
    end
    
  end

  describe "from xml" do

    before(:each) do
      @agreement=Agree2::Agreement.new(@user,@json)
    end

    it "should have a user" do
      @agreement.user.should==@user
    end

    it "should have title" do
      @agreement.title.should=="Agreement to pay [currency=USD] [amount=100] to [recipient]"
    end

    it "should have permalink" do
      @agreement.permalink.should=="hello"
    end

    it "should have a nil body" do
      @agreement.body.should be_nil
    end
    
    it "should have a path" do
      @agreement.path.should=="/agreements/hello"
    end
    
    it "should have a url" do
      @agreement.to_url.should=="https://agree2.com/agreements/hello"
    end
        
    [:created_at,:updated_at,:fields,:state,:active_version,:version,
      :digest,:finalized_at,:finalized_at,:terminated_at,:activated_at,:valid_to].each do |field|
          it "should have #{field}" do
            @agreement.send(field).should_not be_nil
          end
    end
    
    it "should have fields" do
      @agreement.fields.should=={
        "amount"=> "100",
        "currency"=> "USD"
      }
    end    
    
  end

  describe "load from server" do
    before(:each) do
      @user.should_receive(:get).with("/agreements/hello.json").and_return(@json)
    end

    def do_get
      @agreement=Agree2::Agreement.get(@user,"hello")
    end

    it "should have a user" do
      do_get
      @agreement.user.should==@user
    end

    it "should have title" do
      do_get
      @agreement.title.should=="Agreement to pay [currency=USD] [amount=100] to [recipient]"
    end

    it "should have permalink" do
      do_get
      @agreement.permalink.should=="hello"
    end

  end
end

