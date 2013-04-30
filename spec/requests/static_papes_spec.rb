require 'spec_helper'

describe "StaticPapes" do

  #let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  describe "Home page" do

    before { visit home_path }

    it "should have the h1 'Sample App'" do
      page.should have_selector('h1', :text => 'Sample App')
    end

    it "should have the title 'Home'" do
      page.should have_selector('title',
                                #:text => "#{base_title} | Home")
                                :text => full_title('Home'))
    end

    it "should have a custom page title" do
      page.should have_selector('title',
                                :text => "| Home")
    end

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, :user => user, :content => "Lorem ipsum")
        FactoryGirl.create(:micropost, :user => user, :content => "Dolor sit amet")
        sign_in user
        visit home_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", :text => item.content)
        end
      end
    end

  end

  describe "Help page" do

    before { visit help_path }

    it "should have the h1 'Help'" do
      page.should have_selector('h1', :text => 'Help')
    end

    it "should have the title 'Help'" do
      page.should have_selector('title',
                                #:text => "#{base_title} | Help")
                                 :text => full_title('Help'))
    end

  end

  describe "About page" do

    before { visit about_path }

    it "should have the h1 'About Us'" do
      page.should have_selector('h1', :text => 'About Us')
    end

    it "should have the title 'About Us'" do
      page.should have_selector('title',
                                #:text => "#{base_title} | About Us")
                                :text => full_title('About Us'))
    end
  end

  describe "Contact" do

    before { visit contact_path }

    it "should have the h1 'Contact'" do
      page.should have_selector('h1', :text => 'Contact')
    end

    it "should have the title 'Contact'" do
      page.should have_selector('title',
                                #text => "#{base_title} | Contact")
                                :text => full_title('Contact'))
    end
  end

end
