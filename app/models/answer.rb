class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'

  validates :body, :question_id, presence: true

  scope :sort_by_best, -> { order(selected: :desc) }

  def is_best?
    self.selected
  end
end
