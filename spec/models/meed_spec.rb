require 'rails_helper'

RSpec.describe Meed, type: :model do
  it { should belong_to :question }
  it { should belong_to(:answer).optional }

  it { should validate_presence_of :name }

  it 'have one attached img' do
    expect(Meed.new.img).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
