require 'rails_helper'

RSpec.describe Answer, type: :model do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, question: question) }
  let!(:answer_best) { create(:answer, question: question, selected: true) }

  it { should belong_to :question }

  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should allow_value(true, false).for(:selected) }

  it 'select the best answer' do
    answer.select_best
    expect(answer.reload.selected).to eq true
    expect(answer_best.reload.selected).to eq false
  end
end
