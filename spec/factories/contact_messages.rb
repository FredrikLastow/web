# encoding: UTF-8
FactoryGirl.define do
  factory :contact_message do
    skip_create
    name 'Hilbert Älg'
    email 'utomifran@gmail.se'
    message { generate(:description) }
  end
end
