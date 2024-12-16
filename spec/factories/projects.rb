FactoryBot.define do
  factory :project do
    name { Faker::Commerce.product_name }
    description { Faker::Marketing.buzzwords }
    association :created_by, factory: :user

    trait :with_tasks do
      after(:create) do |project|
        create_list(:task, 3, project: project)
      end
    end

    trait :with_repositories do
      after(:create) do |project|
        create_list(:repository, 3, project: project)
      end
    end

    trait :with_boards do
      after(:create) do |project|
        create_list(:board, 3, project: project)
      end
    end

    trait :with_tasks_repositories_and_boards do
      with_tasks
      with_repositories
      with_boards
    end
  end
end
