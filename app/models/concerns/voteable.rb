module Voteable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :voteable, dependent: :destroy
    has_many :voters, class_name: 'User', dependent: :destroy, foreign_key: :voter_id

    def all_votes
      votes.count
    end

    def rating
      count_votes = all_votes
      count_useful_votes = votes.where(useful: true).count
      count_votes > 0 ? (count_useful_votes / count_votes * 100) : count_votes
    end
  end
end
