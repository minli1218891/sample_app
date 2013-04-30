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

require 'securerandom'

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password
  has_many :microposts, :dependent => :destroy

  before_save { |user| user.email = email.downcase }       #存入数据库前email转换为小写
  before_save :create_remember_token

  validates :name, :presence => true, :length => { :maximum => 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true,                     #保证email不为空
            :format => { :with => VALID_EMAIL_REGEX },     #保证email的格式
            :uniqueness => { :case_sensitive => false }    #保证email不区分大小写

  validates :password, :presence => true, :length => { :minimum => 6}
  validates :password_confirmation, :presence => true


  def feed
    Micropost.where("user_id = ?" ,id)
  end


  private
    def create_remember_token
      self.remember_token = SecureRandom.hex
    end
end
