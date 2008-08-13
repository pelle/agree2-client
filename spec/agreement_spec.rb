require File.join(File.dirname(__FILE__),"spec_helper")
require 'open-uri'
require 'hpricot'
describe Agree2::Agreement do
  before(:each) do
    @client=Agree2::Client.new "client_key","client_secret"
    @user=Agree2::User.new(@client,"token","token_secret")
    @xml="<agreement><permalink>hello</permalink><title>My Title</title><body>My Body</body></agreement>"
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
      @agreement=Agree2::Agreement.new(@user,@xml)
    end

    it "should have a user" do
      @agreement.user.should==@user
    end

    it "should have title" do
      @agreement.title.should=="My Title"
    end

    it "should have permalink" do
      @agreement.permalink.should=="hello"
    end

    it "should have body" do
      @agreement.body.should=="My Body"
    end
    
    it "should have a path" do
      @agreement.path.should=="/agreements/hello"
    end
    
    it "should have a url" do
      @agreement.to_url.should=="https://agree2.com/agreements/hello"
    end
  end

  describe "load from server" do
    before(:each) do
      @user.should_receive(:get).with("/agreements/hello.xml").and_return(@xml)
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
      @agreement.title.should=="My Title"
    end

    it "should have permalink" do
      do_get
      @agreement.permalink.should=="hello"
    end

    it "should have body" do
      do_get
      @agreement.body.should=="My Body"
    end
  end
  describe  "load from file" do
    before(:each) do
      @agreement=Agree2::Agreement.new @user,open(File.join(File.dirname(__FILE__),"fixtures","agreement.xml"))
    end
    
    it "should have title" do
      @agreement.title.should=="Option for [holder=pelleb@gmail.com] to buy [asset=Gold]"
    end
    
    it "should have permalink" do
      @agreement.permalink.should=="86d1ac0be392f88a6ea7e3c6f684b0c926ba7012"
    end
    [:permalink,:title,:body,:created_at,:updated_at,:fields,:state,:active_version,:version,:digest,:finalized_at,:finalized_at,:terminated_at,:activated_at,:valid_to].each do |field|
      it "should description" do
        @agreement.send(field).should_not be_nil
      end
    end
    it "should have fields" do
      @agreement.fields.should=={
        'valid_to'=>"6th of October, 2008",
        'holder'=>"pelleb@gmail.com",
        'price'=>"$34",
        'units'=>"grams",
        'amount'=>"100",
        'asset'=>"Gold"
      }
    end
  end
end

