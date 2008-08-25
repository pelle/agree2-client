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
  
  describe "http calls" do
    before(:each) do
      @token=@user.access_token
      @json='{"hello":"world"}'
      @response=mock("response")
      @response.stub!(:code).and_return("200")
      @response.stub!(:body).and_return(@json)
    end
    
    [:get,:head,:delete].each do |m|
      it "should perform http #{m.to_s}" do
        @token.should_receive(m).with("/test",{'Content-Type'=>'application/json','Accept'=>'application/json'}).and_return(@response)
        @user.send(m,"/test").should==@json
      end
    end

    [:post,:put].each do |m|
      it "should perform http #{m.to_s} with no data" do
        @token.should_receive(m).with("/test",nil,{'Content-Type'=>'application/json','Accept'=>'application/json'}).and_return(@response)
        @user.send(m,"/test").should==@json
      end

      it "should perform http #{m.to_s} with hash" do
        @token.should_receive(m).with("/test",'{"test":"this"}',{'Content-Type'=>'application/json','Accept'=>'application/json'}).and_return(@response)
        @user.send(m,"/test",{:test=>'this'}).should==@json
      end
    end
    
    describe "handle_response" do
      it "should return body" do
        @user.send(:handle_response,@response).should==@json
      end

      it "should return handle redirect" do
        @response.stub!(:code).and_return("302")
        @response.stub!(:[]).and_return('https://agree2.com/agreements/my_agreement')
        @user.should_receive(:get).with('/agreements/my_agreement.json').and_return('{"permalink":"my_agreement","title":"hello there"}')
        @agreement=@user.send(:handle_response,@response)
        @agreement.permalink.should=='my_agreement'
        @agreement.title.should=='hello there'
      end
      
    end
  end
end