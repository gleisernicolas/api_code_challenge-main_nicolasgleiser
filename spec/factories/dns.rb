FactoryBot.define do
  factory :dns do
    ip { Faker::Internet.ip_v4_address }

    trait :with_hostnames do
      after(:create) do |dns|
        create_list(:dns_hostname, 3, dns: dns)
      end
    end
  end
end