# frozen_string_literal: true

FactoryBot.define do
  factory :empty_session, class: 'Core::Models::Authentication::Session' do
    factory :session do
      token { SecureRandom.hex }
    end
  end
end
