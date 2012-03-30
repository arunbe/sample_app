require 'spec_helper'

describe "Authentication" do
  subject { page }
  describe "signin" do
  before { visit signin_path }
  it{ should have_selector('h1', text: 'Sign in') }
  it{ should have_selector('title', text: 'Sign in')}    

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_selector('title', text: 'Sign in') }
      it { should have_selector('div.alert.alert-error') }
      
      describe "after visiting another page with invalid flash error"
          before { click_link "Home" }
          it { should_not have_selector('div.alert.alert-error')}
     end
     
      describe "with valid information" do
       let(:user) { FactoryGirl.create(:user) }
        before { sign_in(user)}
      
        it { should have_selector('title', text: user.name) }
        it { should have_link('Profile', href: user_path(user)) }
         it { should_not have_link('Sign in', href: signin_path) }
        it { should have_link('Sign out', href: signout_path) }
      
        describe "followed by signout" do
          before { click_link "Sign out" }
          it { should have_link('Sign in') }
       end
    end   
  end    
end 
