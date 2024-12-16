FactoryBot.define do
  factory :task do
    title { Faker::Name.name }
    description { Faker::Lorem.sentence }
    association :board
    association :creator, factory: :user
    workflow_status { TaskStatus::TODO }
    due_date { "2024-12-13 05:38:13" }
  end
end
