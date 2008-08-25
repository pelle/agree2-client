require File.join(File.dirname(__FILE__),"spec_helper")
require 'open-uri'
#require 'hpricot'
require 'oauth/request_proxy/rack_request'
require 'rack/request'
require 'rack/mock'

include Agree2
describe Party do
  before(:each) do
    @client=Agree2::Client.new "client_key","client_secret"
    @user=Agree2::User.new(@client,"token","token_secret")
    @agreement=Agreement.new @user,{:permalink=>'hello'}
    @json=IO.read(File.join(File.dirname(__FILE__),"fixtures","party.json"))
  end
  
  describe "Create new" do
    before(:each) do
      @party=Party.new(@agreement,{:first_name=>"Bob",:last_name=>"Wildcat",:email=>'bob@gmail.inv'})
    end
    it "should be new record" do
      @party.should be_new_record
    end
    
    it "should have agreement" do
      @party.agreement.should==@agreement
    end
    
    it "should have a user" do
      @party.user.should==@user
    end
    
    it "should have first_name" do 
      @party.first_name.should=="Bob"
    end
  
    it "should have last_name" do 
      @party.last_name.should=="Wildcat"
    end
    
    describe "Save to Server" do
      before(:each) do      
        @user.should_receive(:post).with("/agreements/hello/parties",
          {'party'=>{:first_name=>"Bob",:last_name=>"Wildcat",:email=>'bob@gmail.inv'}}).and_return(@json)
      end
      
      it "should save and return true" do
        @party.save
      end

      it "should no longer be new record" do
        @party.save
        @party.should_not be_new_record
      end

      it "should have a permalink" do
        @party.save
        @party.id.should==1102
      end
    end
    
  end

  describe "from json" do

    before(:each) do
      @party=Party.new(@agreement,@json)
    end

    it "should have agreement" do
      @party.agreement.should==@agreement
    end
    
    it "should have a user" do
      @party.user.should==@user
    end
    
    it "should have first_name" do 
      @party.first_name.should=="Bob"
    end
  
    it "should have last_name" do 
      @party.last_name.should=="Wildcat"
    end
    
    it "should have a path" do
      @party.path.should=="/agreements/hello/parties/1102"
    end
    
    it "should have a url" do
      @party.to_url.should=="https://agree2.com/agreements/hello/parties/1102"
    end
    
    it "should generate present url" do
      present_url=@party.present
      present_url=~/^(http.*)\?(.*)$/
      $1.should=="https://agree2.com/present/hello/to/bob@gmail.inv"
    end
    
    it "should verify present url" do
      present_url=@party.present
      request = Rack::Request.new(Rack::MockRequest.env_for(present_url))
      OAuth::Signature.verify(request,{:consumer=>@client.consumer,:token=>@user.access_token}).should==true
      
    end
    
    describe "Save to Server" do
      before(:each) do      
        @user.should_receive(:put).with("/agreements/hello/parties/1102",
          {'party'=>@party.attributes}).and_return(@json)
      end
      
      it "should save and return true" do
        @party.save
      end

    end
    
  end
end

describe Agree2::Party, "party hash validation" do
  before(:each) do
    @hash={:first_name=>'Bob',:last_name=>'Wilson',:email=>'bob@gmail.com',:organization_name=>'SomeCo Inc.'}
  end
  
  it "should validate" do
    lambda {Party.validate_party_hash(@hash).should==true}.should_not raise_error
  end

  [:first_name,:last_name,:email].each do |field|
    it "should require #{field.to_s}" do
      @hash.delete(field)
      lambda {Party.validate_party_hash(@hash)}.should raise_error(ArgumentError)
    end
  end

end