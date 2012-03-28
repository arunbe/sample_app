FactoryGirl.define do
  factory :user do
    name      "michael"
    email     "michae@gmail.com"
    password  "foobar"
    password_confirmation  "foobar"
  end
end