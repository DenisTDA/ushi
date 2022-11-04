class Meed < ApplicationRecord
  belongs_to :question
  belongs_to :answer, optional: true
  has_one_attached :img, dependent: :destroy

  validates :name, presence: true

  scope :of_user, ->(user) { where(answer: user.replies) }
end
