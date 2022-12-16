require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:votes) }
  it { should have_many(:answers).through(:votes) }
  it { should have_many(:questions).through(:votes) }
  it { should have_many(:problems).class_name 'Question' }
  it { should have_many(:replies).class_name 'Answer' }
  it { should have_many(:authorizations).dependent(:destroy) }

  it { should validate_presence_of :email }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let!(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
    let(:service) { double('Registration::FindForOauth') }

    it 'calls  Registration::FindforOauth' do
      expect(Registration::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
