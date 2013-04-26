namespace :db do
  describe "Fill database with sample date"
  task :populate => :environment do
    admin = User.create!(:name => "Example User",
                 :email => "rails@railstutorial.org",
                 :password => "foobar",
                 :password_confirmation => "foobar")
    admin.toggle!(:admin)

    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password = "foobar"
      User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end
  end
end