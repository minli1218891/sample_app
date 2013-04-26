require 'spec_helper'

describe "Authentication" do

  describe "authorization" do

    describe "for non-signed-in user" do
      let(:user) { User.create(:name => "Rails Tutorial",
                               :email => "user@example.com",
                               :password => "foobar",
                               :password_confirmation => "foobar") }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email", :with => user.email
          fill_in "Password", :with => user.password
          click_button "Sign in"
        end

        describe "after signing in" do
          it "should rendor the desired protected page" do
            page.should have_selector('title', :text => 'Edit user')
          end
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it "should have title Sign in" do
            page.should have_selector('title', :text => 'Sign in')
          end
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          it "should response to sigin_path" do
            response.should redirect_to(signin_path)
          end
        end

        describe "visiting th user index" do
          before { visit users_path }
          it "should have title 'Sign in'" do
            page.should have_selector('title', :text => 'Sign in')
          end
        end

      end
    end

    describe "as wrong user" do
      let(:user) { User.create(:name => "Rails Tutorial",
                               :email => "user@example.com",
                               :password => "foobar",
                               :password_confirmation => "foobar") }
      let(:wrong_user) { User.create(:name => "Rails Tutorial",
                               :email => "wrong@example.com",
                               :password => "foobar",
                               :password_confirmation => "foobar") }
      before { sign_in user }

      describe "visiting Users#edit page" do
        it "should not have the title edit" do
          page.should_not have_selector('title', :text => full_title('Edit user'))
        end
      end

      describe "submitting a PUT request to the User#update action" do
        before { put user_path(wrong_user) }
        it "should redirect to the home path" do
          response.should redirect_to(home_path)
        end
      end

      describe "as non-admin user" do
        let(:user) { User.create(:name => "Rails Tutorial",
                                 :email => "user@example.com",
                                 :password => "foobar",
                                 :password_confirmation => "foobar") }
        let(:non_admin) { User.create(:name => "Rails Tutorial",
                                       :email => "wrong@example.com",
                                       :password => "foobar",
                                       :password_confirmation => "foobar") }
        before { sign_in non_admin }

        describe "submitting a DELETE request to the Users#destroy action" do
          before { delete user_path(user) }
          specify { response.should redirect_to(home_path)}
        end
      end

    end


    end

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

        it "should have the link 'Profile' 'Setting' and 'Sign out'" do
          page.should have_link('Profile', :href => user_path(:user))
          page.should have_link('Settings', :href => edit_user_path(:user))
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


      describe "with valid information" do
        let(:user) { User.create(:name => "Rails Tutorial",
                                 :email => "user@example.com",
                                 :password => "foobar",
                                 :password_confirmation => "foobar") }
        before { sign_in user }

        it "should have the title user's name" do
          page.should have_selector('title', :text => user.name)
        end

        it "should have the link 'Users'" do
          page.should have_link("Users", :href => users_path)
        end

        it "should have the link 'profile', 'setting' and 'signout'" do
          page.should have_link("Profile", :href => user_path(user))
          page.should have_link("Setting", :href => edit_user_path(user))
          page.should have_link("Sign out", :href => signout_path)
        end

        it "should not have the link 'signin'" do
          page.should_not have_selector("Sign in", :href => signin_path)
        end
      end

    end

  end
