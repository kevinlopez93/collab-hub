FactoryBot.define do
  factory :repository do
    remote_id { 1 }
    node_id { 2 }
    name { Faker::Name.name }
    full_name { Faker::Name.name }
    private { false }
    owner_login { Faker::Name.name }
    description { "#{Faker::Lorem.sentence}" }
    url_api { Faker::Internet.url }
    url_html { Faker::Internet.url }
    remote_created_at { "2024-12-15 07:39:08" }
    remote_updated_at { "2024-12-15 07:39:08" }
    visibility { "public" }
    association :project
  end
end
