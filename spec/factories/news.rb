# encoding: UTF-8
FactoryGirl.define do
  factory :news do
    title
    content { generate(:description) }
    user
    url

    trait :with_image do
      image Rack::Test::UploadedFile.new(File.open('spec/assets/image.jpg'))
    end
  end
end
