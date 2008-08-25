require File.join(File.dirname(__FILE__),"spec_helper")

describe Agree2::Template do
  before(:each) do
    @client=Agree2::Client.new "client_key","client_secret"
    @user=Agree2::User.new(@client,"token","token_secret")
    @template=Agree2::Template.new(@user,{:permalink=>'hello'})
    @fields={:amount=>100}
    @bob={:first_name=>'Bob',:last_name=>'Green',:email=>'bob@green.inv'}
    @json=IO.read(File.join(File.dirname(__FILE__),"fixtures","agreement.json"))
    
  end

  it "should have a user" do
    @template.user.should==@user
  end
  
  it "should have correct path" do
    @template.path.should=="/masters/hello"
  end
  
  it "should have correct url" do
    @template.to_url.should=="https://agree2.com/masters/hello"
  end

  describe "prepare" do
    before(:each) do
      @agreement=mock('agreement')
      @user.stub!(:get).and_return(@agreement)
    end
    
    it "should call raw_prepare with correct parameters" do
      @template.should_receive(:raw_prepare).with(:fields=>@fields,:parties=>{:client=>@bob})
      @template.prepare(@fields,{:client=>@bob})
    end

    it "should call raw_prepare with correct parameters for application" do
      @template.should_receive(:raw_prepare).with(:fields=>@fields,:parties=>{:client=>@bob,'service'=>:application})
      @template.prepare(@fields,{:client=>@bob},'service')
    end

    it "should call raw_prepare with correct parameters" do
      @user.should_receive(:post).with("/masters/hello/prepare",:fields=>@fields,:parties=>{:client=>@bob}).and_return(@json)
      @template.prepare(@fields,{:client=>@bob})
    end

    it "should raise exception and not receive raw_prepare when parties aren't valid" do
      @bob.delete(:email)
      @template.should_not_receive(:raw_prepare)
      lambda {@template.prepare(@fields,{:client=>@bob})}.should raise_error(ArgumentError)
    end
  end
  
  describe "prepare and sign" do
    before(:each) do
      @agreement=mock('agreement')
      @user.stub!(:get).and_return(@agreement)
    end
    
    it "should call raw_prepare with correct parameters" do
      @template.should_receive(:raw_prepare).with(:fields=>@fields,
                :parties=>{:client=>@bob,'application'=>:application},:sign=>'application')
      @template.prepare_and_sign(@fields,{:client=>@bob})
    end

    it "should call raw_prepare with correct parameters for application" do
      @template.should_receive(:raw_prepare).with(:fields=>@fields,:parties=>{:client=>@bob,'service'=>:application},:sign=>'service')
      @template.prepare_and_sign(@fields,{:client=>@bob},'service')
    end

    it "should call raw_prepare with correct parameters" do
      @user.should_receive(:post).with("/masters/hello/prepare",:fields=>@fields,
                :parties=>{:client=>@bob,'application'=>:application},:sign=>'application').and_return(@json)
      @template.prepare_and_sign(@fields,{:client=>@bob})
    end

    it "should raise exception and not receive raw_prepare when parties aren't valid" do
      @bob.delete(:email)
      @template.should_not_receive(:raw_prepare)
      lambda {@template.prepare_and_sign(@fields,{:client=>@bob})}.should raise_error(ArgumentError)
    end

    it "should raise exception and not receive raw_prepare when no parties are present" do
      @bob.delete(:email)
      @template.should_not_receive(:raw_prepare)
      lambda {@template.prepare_and_sign(@fields,{})}.should raise_error(ArgumentError)
    end
  end
end