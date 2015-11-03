# Read about factories at https://github.com/thoughtbot/factory_girl
include ActionDispatch::TestProcess
FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "User #{n}" }
    sequence(:email) { |n| "user#{n}@example.com"}
    password 'password'
    password_confirmation 'password'
  end

  factory :image do
    image { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'test.jpg'), 'image/jpg') }
    owner { FactoryGirl.create(:user) }
  end

  factory :vote do
    latitude 2.3
    longitude 2.4
  end
end
