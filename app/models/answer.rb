class Answer < ApplicationRecord
  include Voteable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :author, class_name: 'User'

  has_one :meed, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, :question_id, presence: true

  after_create_commit :notify_subscribers

  scope :sort_by_best, -> { order(selected: :desc) }

  def is_best?
    selected
  end

  def select_best
    transaction do
      self.class.where(question_id: question_id).update_all(selected: false)
      update(selected: true)
      question.meed&.update(answer: self)
    end
  end

  private

  def notify_subscribers
    NotifySubscribersJob.perform_later(self)
  end
end
