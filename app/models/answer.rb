class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'

  has_many_attached :files

  validates :body, :question_id, presence: true

  scope :sort_by_best, -> { order(selected: :desc) }

  def is_best?
    selected
  end

  def select_best
    transaction do
      self.class.where(question_id: question_id).update_all(selected: false)
      update(selected: true)
    end
  end
end
