source 'http://rubygems.org'
#source 'https://ruby.taobao.org'

gem 'rails', '3.2.13'
#gem 'rails', '3.2.12'
gem 'bootstrap-sass', '2.0.0'
gem 'bcrypt-ruby', '3.0.1'      #对密码进行不可逆的加密，得到密码的哈希值
gem 'faker', '1.0.1'
gem 'will_paginate', '3.0.3'
gem 'bootstrap-will_paginate', '0.0.6'

group :development, :test do
  gem 'sqlite3', '1.3.5', :group => [:development, :test]
  gem 'rspec-rails', '2.11.0'  #生成rspec测试的gem包
  gem 'annotate', '2.5.0'      #自动生成注释的gem包
end


group :assets do
  gem 'sass-rails',   '~> 3.2.5'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier', '1.2.3'
end

gem 'jquery-rails', '2.0.2'

group :test do
  gem 'capybara', '1.1.2'
  #gem 'factory_girl_rails', '4.1.0'
  #if RUBY_VERSION =~ /1.9/
  #  gem 'factory_girl_rails', :require => false
  #  gem 'simplecov'
  #else
    gem 'factory_girl_rails', '1.3.0'
    #gem 'rcov'
  #end
  gem 'cucumber-rails', '1.2.1', :require => false
  gem 'database_cleaner', '0.7.0'
end

group :production do
  gem 'pg', '0.12.2'
  gem 'thin'
  gem 'heroku'
end