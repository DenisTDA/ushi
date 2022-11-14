module Voteable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :voteable, dependent: :destroy
    has_many :voters, class_name: 'User', dependent: :destroy, foreign_key: :voter_id
  end
end
