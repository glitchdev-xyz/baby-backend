FactoryBot.define do
  factory :session do
    ip_address {'192.168.1.1'}
    user_agent {'Mozilla'}
    token {'random'}
    user
  end
end
