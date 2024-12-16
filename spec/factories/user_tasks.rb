FactoryBot.define do
  factory :user_task do
    association :task
    association :user
  end
end
