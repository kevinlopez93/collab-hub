FactoryBot.define do
  factory :user do
    username { Faker::Internet.username }
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    trait :admin do
      role { RoleUserEnum::ADMIN }
    end

    trait :project_manager do
      role { RoleUserEnum::PROJECT_MANAGER }
    end

    trait :developer do
      role { RoleUserEnum::DEVELOPER }
    end
  end
end
