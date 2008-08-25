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
    
    it "should have attribute hash" do
      @agreement.attributes.should=={:title=>"My Title",:body=>"My Body"}
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
    
    it "should be new record" do
      @agreement.should be_new_record
    end
    
    describe "Save to Server" do
      before(:each) do
        @user.should_receive(:post).with("/agreements",{'agreement'=>{:title=>"My Title",:body=>"My Body"}}).and_return(@json)
      end
      
      it "should save and return true" do
        @agreement.save
      end

      it "should no longer be new record" do
        @agreement.save
        @agreement.should_not be_new_record
      end

      it "should have a permalink" do
        @agreement.save
        @agreement.permalink.should_not be_nil
      end
    end
  end

  describe "from json" do

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
    
    it "should have methods defined for fields" do
      @agreement.amount.should=="100"
      @agreement.currency.should=="USD"
    end
    [:amount,:currency].each do |field|
      it "should support setting the value" do
        @agreement.send("#{field.to_s}=".to_sym,"test this")
        @agreement.send(field).should=="test this"
        @agreement.fields[field.to_s].should=="test this"
      end
      
      it "should have respond_to wired for field accessor" do
        @agreement.respond_to?(field).should==true
      end
      
      it "should have respond_to wired for field setter" do
        @agreement.respond_to?("#{field.to_s}=".to_sym).should==true
      end
    end
    
    it "should not be new record" do
      @agreement.should_not be_new_record
    end
    
    it "should reload" do
      @user.should_receive(:get).with("/agreements/hello").and_return(@json)
      @agreement.reload
    end

    it "should destroy" do
      @user.should_receive(:delete).with("/agreements/hello").and_return("")
      @agreement.destroy
    end
    
    it "should finalize" do
      @user.should_receive(:post).with("/agreements/hello/finalize").and_return(" ")
      @agreement.finalize!.should==true
    end
    
    describe "Save to Server" do
      before(:each) do
        @user.should_receive(:put).with("/agreements/hello",{"fields"=>@agreement.fields}).and_return(@json)
      end
      
      it "should save and return true" do
        @agreement.save
      end

      it "should not a be new record" do
        @agreement.save
        @agreement.should_not be_new_record
      end

      it "should have a permalink" do
        @agreement.save
        @agreement.permalink.should_not be_nil
      end
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
    
    it "should not be new record" do
      do_get
      @agreement.should_not be_new_record
    end
    
  end
end

