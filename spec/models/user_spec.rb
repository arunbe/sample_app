require 'spec_helper'

describe User do
  before { @user = User.new(name: "exampleUser", email: "user@example.com", 
          password: "foobar", password_confirmation: "foobar") }
  
  subject {@user}
  
  it{ should respond_to(:name) }
  it{ should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it {should respond_to(:password)}
  it {should respond_to(:password_confirmation)} 
  it {should respond_to(:remember_token)}
  it {should respond_to(:authenticate)} 
  it { should respond_to(:microposts) }
  it { should respond_to(:feed)}
   it{ should be_valid }
   
   describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
    
    describe "with a password that's too short" do
       before { @user.password = @user.password_confirmation = "a" * 5 }
       it { should be_invalid }
    end
  
   describe "return value of authenticate method" do
      before { @user.save }
      let(:found_user) { User.find_by_email(@user.email) }

        describe "with valid password" do
         it { should == found_user.authenticate(@user.password) }
        end

        describe "with invalid password" do
          let(:user_for_invalid_password) { found_user.authenticate("invalid") }

          it { should_not == user_for_invalid_password }
          specify { user_for_invalid_password.should be_false }
        end
   
        describe "when name is not present" do
          before { @user.name = ""}
          it { should_not be_valid }
        end
   
        describe "when password is not present" do
           before { @user.password = @user.password_confirmation = "" }
            it{ should_not be_valid }
        end 
   
        describe "when password doesn't match confirmation" do
           before { @user.password_confirmation = "mismatch" }
           it { should_not be_valid }
        end
  
        describe "when the password is nil " do
          before{ @user.password_confirmation = nil }
          it { should_not be_valid }
        end

   
        describe "when name is too long" do
          before { @user.name = "a" * 51 }
          it { should_not be_valid }
        end
   
   
        describe "when email address is exists as same" do
          before do
          user = User.create(name: "exampleUser", email: "user2@example.com", 
          password: "foobar", password_confirmation: "foobar")
          @user.email = user.email
          @user.save
        end
       it { should_not be_valid }
   end
  end
  
  describe "micropost associations" do
    before { @user.save }
    let!(:older_micropost) do 
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      @user.microposts.should == [newer_micropost, older_micropost]
    end
    
    it "should destroy associated users" do
      microposts = @user.microposts
      @user.destroy
      microposts.each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end
    
    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      
      its(:feed) { should include(older_micropost) }
      its(:feed) { should include(newer_micropost) }
      its(:feed) { should_not include(unfollowed_micropost)}
    end
  end
end
