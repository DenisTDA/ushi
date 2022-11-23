require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:votes) }
  it { should have_many(:answers).through(:votes) }
  it { should have_many(:questions).through(:votes) }
  it { should have_many(:problems).class_name 'Question' }
  it { should have_many(:replies).class_name 'Answer' }
end
