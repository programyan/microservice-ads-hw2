FactoryBot.define do
  factory :ad do
    sequence(:title) { |index| "Ad title ##{index}" }
    sequence(:description) { |index| "Ad description ##{index}" }
    city { %w(Khabarovsk Saint-Petersburg).sample }
    user_id { rand(1..10) }
  end
end