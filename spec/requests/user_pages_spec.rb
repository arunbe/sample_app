require 'spec_helper'

describe "UserPages" do
  subject {page}
  
    describe "Signup page" do
      before{ visit signup_path }
    
      it { should have_selector('h1',text: 'Sign up') }
      it { should have_selector('title',text: full_title('signup'))}
    end
  
      describe "Profile page" do
        let(:user){ FactoryGirl.create(:user) }
        before { visit user_path(user) }
        it { should have_selector('h1', text: user.name) }
        it { should have_selector('title', text: user.name) }
      end
      
      describe "Signup page" do
        before { visit signup_path }
          describe "with invalid information" do
            it "should not create the user" do
              expect { click_button "Create my account" }.not_to change(User, :count)
            end
           end
            describe "with valid information" do
                before do
                  fill_in "Name" , with: "example user"
                  fill_in "Email", with: "user@yahoo.com"
                  fill_in "Password" , with: "foobar"
                  fill_in "Password confirmation", with: "foobar" 
                end 
                describe "after saving the user" do
                 before { click_button "Create my account" }
                  let(:user) { User.find_by_email('user@example.com') }
              
                  it { should have_selector('title', text: user.name) }
                  it { should have_selector('div.alert.alert-success', text: 'Welcome') }
                  it { should have_link('Sign out') }
                end
                it "should create the user" do
                expect do 
                click_button "Create my account"
               end.to change(User, :count).by(1)
               
           end
       end
    end
end