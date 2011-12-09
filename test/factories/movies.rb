# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :movie do
    title "MyString"
    release_year "MyString"
    link_to_image "MyString"
    description "MyText"
    length 1
  end
end
