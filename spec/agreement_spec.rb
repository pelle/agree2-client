require File.join(File.dirname(__FILE__),"spec_helper")

describe Agree2::Agreement do
  
  before(:each) do
    @user=mock("user")
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

# describe Agree2::Agreement, "parsed from xml" do
#   
#   before(:each) do
#     @user=mock("user")
#     @agreements=Agree2::Agreement.new(@user,"<agreements><agreement><permalink>hello</permalink><title>My Title</title><body>My Body</body></agreement></agreements>")
#     @agreement=@agreements.first
#   end
#   
#   it "should have 1 agreement" do
#     @agreements.length.should==1
#   end
#   it "should have a user" do
#     @agreement.user.should==@user
#   end
#   
#   it "should have title" do
#     @agreement.title.should=="My Title"
#   end
# 
#   it "should have permalink" do
#     @agreement.permalink.should=="hello"
#   end
#   
#   it "should have body" do
#     @agreement.body.should=="My Body"
#   end
#   
# end
