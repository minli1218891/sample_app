FactoryGirl.define do
  factory :use do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:name) { |n| "Person_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
  end
end