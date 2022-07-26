module Commentable
  extend ActiveSupport::Concern
  included do
    has_many :comments, as: :commentable, dependent: :destroy
    has_many :users, through: :comments
  end
end
