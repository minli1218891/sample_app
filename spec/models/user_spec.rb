# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'
require 'SecureRandom'

describe User do

  before do
    @user = User.new(:name => "Example User",
                     :email => "user@example.com",
                     :password => "foobar",
                     :password_confirmation => "foobar")
  end

  subject { @user }


  it "should respond to attributes" do              #验证存在性
    @user.should respond_to(:name)
    @user.should respond_to(:email)
    @user.should respond_to(:password_digest)
    @user.should respond_to(:password)
    @user.should respond_to(:password_confirmation)
    @user.should respond_to(:remember_token)
    @user.should respond_to(:admin)
    @user.should respond_to(:authenticate)

    @user.should respond_to(:microposts)

    @user.should be_valid
    @user.should_not be_admin
  end

  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }


  describe "with admin attribute set to 'true'" do
    before do
      @user.save
      @user.toggle!(:admin)
    end
    it "should be admin" do
      @user.should be_admin
    end
  end

  describe "when name is not present" do           #验证名字不合法
    before { @user.name = " " }
    it "should not be valid" do
      @user.should_not be_valid
    end
  end

  describe "when email is not present" do          #验证邮箱不合法
    before { @user.email = " " }
    it "should not be valid" do
      @user.should_not be_valid
    end
  end

  describe "when name is too long" do              #验证名字太长
    before { @user.name = "a" * 51 }
    it "should not be valid" do
      @user.should_not be_valid
    end
  end

  describe "when email format is invalid" do       #验证邮箱格式不合法
    it "should not be valid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do         #验证邮箱格式合法
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end

  describe "when email adress is already taken" do     #验证邮箱地址已注册
    before do
      user_with_same_email = @user.dup         # 创建一个和 @user Email 地址一样的用户对象
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it "should not be valid" do
      @user.should_not be_valid
    end
  end

  describe "email address with mixed case" do          #验证邮箱能否正确保存为全小写
    let (:mix_case_email) { "Foo@ExAMPLe.CoM" }

    it "should be saved as lower-case" do
      @user.email = mix_case_email
      @user.save
      @user.reload.email.should == mix_case_email.downcase
    end
  end

  describe "when password is not present" do           #验证密码不合法
    before { @user.password = @user.password_confirmation = "" }
    it "should not be valid" do
      @user.should_not be_valid
    end
  end

  describe "when password doesn't match confirmation" do       #验证两次密码不一致
    before { @user.password_confirmation = "mismatch" }
    it "should not be valid" do
      @user.should_not be_valid
    end
  end

  describe "when password confirmation is nil" do             #验证第二次密码为空
    before { @user.password_confirmation = nil }
    it "should not be valid" do
      @user.should_not be_valid
    end
  end

  describe "with a password that's too short" do               #验证密码太短
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it "should not be valid" do
      @user.should_not be_valid
    end
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let (:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do                    #验证密码合法时返回一个对象
      it "should be valid" do
        @user.should == found_user.authenticate(@user.password)
      end
    end

    describe "with invalid password" do                 #验证密码不合法时返回false
      let (:user_for_invalid_password) { found_user.authenticate("invalid") }
      it "should not be valid" do
        @user.should_not == user_for_invalid_password
        user_for_invalid_password.should be_false
      end
    end
  end

  describe "remember token" do
    before { @user.save }
    it "the remember_token should not be blank" do
      @user.remember_token.should_not be_blank
    end
  end


  describe "micropost associations" do
    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, :user => @user, :created_at => 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, :user => @user, :created_at => 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      @user.microposts.should == [newer_micropost, older_micropost]
    end

    it "should destroy associated microposts" do
      microposts = @user.microposts.dup
      @user.destroy
      microposts.should_not be_empty
      microposts.each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, :user => FactoryGirl.create(:user))
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
    end

  end


  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }


    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end


    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }
      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end

  end

end