FactoryBot.define do
  factory :board do
    name { Faker::Name.name }
    association :project
    association :created_by, factory: :user

    trait :with_tasks do
      after(:create) do |board|
        create_list(:task, 3, board: board)
      end
    end
  end
end
