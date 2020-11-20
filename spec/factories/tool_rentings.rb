FactoryBot.define do
  factory :tool_renting do
    user_id
    purpose 'to use'
    tool
    return_date { Time.zone.now + 10.days }
    returned false
  end
end
