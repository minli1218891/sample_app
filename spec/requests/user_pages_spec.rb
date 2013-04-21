require 'spec_helper'

describe "UserPages" do

  let(:base_title) { "Ruby on Rails Tutorial Sample App" }


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
    end

  end

end
