require 'rails_helper'

RSpec.describe Answer, type: :model do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, question: question) }
  let!(:meed) { create(:meed, question: question) }
  let!(:answer_best) { create(:answer, question: question, selected: true) }

  it { should belong_to :question }
  it { should have_one(:meed).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it_behaves_like 'commentable'

  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should allow_value(true, false).for(:selected) }

  it { should accept_nested_attributes_for(:links) }

  it 'select the best answer' do
    answer.select_best
    expect(answer.reload.selected).to eq true
    expect(answer_best.reload.selected).to eq false
    expect(meed.reload.answer).to eq answer
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
