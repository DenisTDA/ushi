FactoryBot.define do
  factory :oauth_application, class: 'Doorkeeper::Application' do
    name { 'TestApp' }
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
    uid { '12345678' }
    secret { '987654321' }
  end
end
