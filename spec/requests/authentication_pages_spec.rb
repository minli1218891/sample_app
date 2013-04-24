require 'spec_helper'

describe "Authentication" do

  describe "signin" do

    before { visit signin_path }

    describe "with invalid information" do

      before { click_button "Sign in" }

      it "should have the title 'Sign in'" do
        page.should have_selector('title', :text => "Sign in")
      end

      it "should have the error message" do
        #page.should have_selector('div.alert.alert-error', :text => 'Invalid')
        page.should have_error_message('Invalid')
      end

      describe "after visiting another page" do

        before { click_link "Home" }

        it "should not have the error message" do
          page.should_not have_selector('div.alert.alert-error')
        end

      end

    end

    describe "with valid information" do

      let(:user) { User.create(:name => "Rails Tutorial",
                               :email => "user@example.com",
                               :password => "foobar",
                               :password_confirmation => "foobar") }

      before do
        #fill_in "Email",    :with => user.email
        #fill_in "Password", :with => user.password
        #click_link "Sign in"
        valid_signin(user)
      end

      it "should have the title 'Sign in'" do
        page.should have_selector('title', :text => user.name)
      end

      it "should have the link 'Profile' and 'Sign out'" do
        page.should have_link('Profile', :href => user_path(:user))
        page.should have_link('Sign out',:href => signout_path)
      end

      it "should not have the link 'Sign in'" do
        page.should_not have_link('Sign in')
      end

      describe "followed by signout" do
        before { click_link "Sign out" }
        it "should have the link 'Sign in'" do
          page.should have_link('Sign in')
        end
      end

    end

  end

end
