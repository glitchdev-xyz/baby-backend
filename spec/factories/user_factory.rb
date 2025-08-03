FactoryBot.define do
  factory :user do
    sequence(:email_address) { |n| "foo_#{n}@bar.baz" }
    password_digest  { 'password321' }

    # https://thoughtbot.github.io/factory_bot/cookbook/has_many-associations.html
    factory :user_with_sessions do
      transient do
        sessions_count { 2 }
      end
      sessions do
        Array.new(sessions_count) { association(:session) }
      end
    end
  end
end
