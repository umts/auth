# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:entra_uid)
    sequence(:entra_upn) { |n| "#{n}@upn.com" }
    sequence(:first_name) { |n| "First#{n}" }
    sequence(:last_name) { |n| "Last#{n}" }
    sequence(:email) { |n| "#{n}@email.com" }
  end
end
