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
        
         describe "edit" do
           let(:user) { FactoryGirl.create(:user) }
           before { visit edit_user_path(user) }

             describe "page" do
               it { should have_selector('h1',    text: "Update your profile") }
               it { should have_selector('title', text: "Edit user") }
              it { should have_link('change', href: 'http://gravatar.com/emails') }
            end
          
            describe "with invalid information" do
               before { click_button "Save changes" }

               it { should have_content('error') }
            end
          
            describe "with invalid information" do
               it "should not create the user" do
               expect { click_button "Create my account" }.not_to change(User, :count)
                end
            end
            describe "with valid information" do
               let(:new_name)  { "New Name" }
               let(:new_email) { "new@example.com" }
                before do
                  fill_in "Name" , with: "example user"
                  fill_in "Email", with: "user@yahoo.com"
                  fill_in "Password" , with: "foobar"
                  fill_in "Password confirmation", with: "foobar" 
                  click_button "Save changes"
                end 
                describe "after saving the user" do
                 before { click_button "Create my account" }
                  let(:user) { User.find_by_email('user@example.com') }
              
                  it { should have_selector('title', text: user.name) }
                  it { should have_selector('div.alert.alert-success', text: 'Welcome') }
                  it { should have_link('Sign out') }
                  specify { user.reload.name.should  == new_name }
                  specify { user.reload.email.should == new_email }
                end
                it "should create the user" do
                expect do 
                click_button "Create my account"
               end.to change(User, :count).by(1)
           end
       end
    end
  end
end