# frozen_string_literal: true

FactoryBot.define do
  factory :brass do
    name { Faker::Name.unique.name.gsub(/\W/, "") }
    user
    caliber
  end
end
