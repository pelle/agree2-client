require File.join(File.dirname(__FILE__),"spec_helper")
require 'open-uri'
require 'hpricot'
include Agree2
describe Agree2::Agreement do
  before(:each) do
    @client=Agree2::Client.new "client_key","client_secret"
    @user=Agree2::User.new(@client,"token","token_secret")
    @agreement=Agreement.new @user,{:permalink=>'hello'}
    @xml=%q{<party>
        <created-at type="datetime">2008-08-12T22:04:51Z</created-at>
        <email>bob@gmail.inv</email>
        <first-name>Bob</first-name>
        <id type="integer">1102</id>
        <invited-at type="datetime" nil="true"></invited-at>
        <last-name>Wildcat</last-name>
        <organization-name nil="true"></organization-name>
        <role>client</role>
        <updated-at type="datetime">2008-08-12T22:04:51Z</updated-at>
      </party>}
  end
  
  describe "Built from hash" do
    before(:each) do
      @party=Party.new(@agreement,{:first_name=>"Bob",:last_name=>"Wildcat",:email=>'bob@gmail.inv',:id=>1102})
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
    
  end

  describe "from xml" do

    before(:each) do
      @party=Party.new(@agreement,@xml)
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
    
  end
end

