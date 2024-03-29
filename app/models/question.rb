class Question < ApplicationRecord
  include Voteable
  include Commentable

  belongs_to :author, class_name: 'User'

  has_one :meed, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :subscriptions, dependent: :destroy

  has_many_attached :files, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :meed, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
end
