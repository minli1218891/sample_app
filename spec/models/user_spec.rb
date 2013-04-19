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

describe User do

  before { @user = User.new(:name => "minli", :email => "minli@thoughtworks.com") }

  it "should respond to attributes" do
    @user.should respond_to(:name)
    @user.should respond_to(:email)
  end

end
