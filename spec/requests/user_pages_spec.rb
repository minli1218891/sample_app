require 'spec_helper'

describe "UserPages" do

  let(:base_title) { "Ruby on Rails Tutorial Sample App" }


  describe "index" do
    let(:current_user) { User.create(:name => "Micheal Hart1",
                             :email => "user@example.com",
                             :password => "foobar",
                             :password_confirmation => "foobar") }

    before do
      sign_in current_user
      User.create(:name => "Bob",
                  :email => "bob@example.com",
                  :password => "foobar",
                  :password_confirmation => "foobar")
      User.create(:name => "Ben",
                  :email => "ben@example.com",
                  :password => "foobar",
                  :password_confirmation => "foobar")

      visit users_path
    end

    it "should have the title 'All users'" do
      page.should have_selector('title', :text => "All users")
    end

    it "should have the h1 'All users'" do
      page.should have_selector('h1', :text => "All users")
    end

  end


  describe "profile page" do

    let(:user) { User.create(:name => "Micheal Hart1",
                             :email => "user@example.com",
                             :password => "foobar",
                             :password_confirmation => "foobar") }

    before { visit user_path(user) }

    it "should have the h1 user's name" do
      page.should have_selector('h1', :text => user.name)
    end

    it "should have the title user's name" do
      page.should have_selector('title', :text => user.name)
    end

  end


  describe "signup" do

    before { visit signup_path }
    let (:submit) { "Create my account" }

    it "should have the h1 'Sign Up'" do
      page.should have_selector('h1', :text => 'Sign Up')
    end

    it "shoule have the title 'Sign Up'" do
      page.should have_selector('title', :text => "#{base_title} | Sign Up")
    end


    describe "with invalid information" do

      it "should not create a user" do
        expect { click_button submit}.not_to change(User, :count)
      end

      describe "after submission" do

        before {click_button submit }

        it "should have the title 'Sign Up'" do
          page.should have_selector('title', :text => "Sign Up")
        end

        it "should have the content 'error'" do
          page.should have_content('error')
        end

      end

    end

    describe "with valid information" do

      before do
        fill_in "Name",           :with => "Example User"
        fill_in "Email",          :with => "user@example.com"
        fill_in "Password",       :with => "foobar"
        fill_in "Confirmation",   :with => "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do

        before { click_button submit }
          let (:user) { User.find_by_email('user@example.com') }

        it "should have the title user's name" do
          page.should have_selector('title', :text => user.name)
        end

        it "should have the content 'Welcome'" do
          page.should have_selector('div.alert.alert-success', :text => 'Welcome')
        end

        it "should have the link 'Sign out'" do
          page.should have_link('Sign out')
        end

      end

    end


    describe "edit" do
      let(:user) { User.create(:name => "Rails Tutorial",
                               :email => "user@example.com",
                               :password => "foobar",
                               :password_confirmation => "foobar") }
      before do
        sign_in user
        visit edit_user_path(user)
      end

      describe "page" do
        it "should have the h1 'Update your profile'" do
          page.should have_selector('h1', :text => "Update your profile")
        end

        it "should have the title 'Edit user'" do
          page.should have_selector('title', :text => "Edit user")
        end

        it "should have the link 'change'" do
          page.should have_link('change', :href => 'http://gravatar.com/emails')
        end
      end

      describe "with invalid information" do
        before do
          click_button "Save changes"
        end

        it "should have contant 'error'" do
          page.should have_content('error')
        end

      end

      describe "with valid information" do
        let(:new_name){ "New Name" }
        let(:new_email){ "new@example.com" }
        before do
          fill_in "Name", :with => new_name
          fill_in "Email", :with => new_email
          fill_in "Password", :with => user.password
          fill_in "Confirm Password", :with => user.password
          click_button "Save changes"
        end
        it "should have title 'new name'" do
          page.should have_selector('title', :text => new_name)
          page.should have_selector('div.alert.alert-success')
        end

        it "should have link 'Sign out'" do
          page.should have_link("Sign out", :href => signout_path)
        end

        it "should reload name and email" do
          user.reload.name.should == new_name         #检测用户的属性是否已经更新
          user.reload.email.should == new_email
        end
      end

    end

  end

end
