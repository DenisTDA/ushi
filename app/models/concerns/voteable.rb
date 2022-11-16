module Voteable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :voteable, dependent: :destroy
    has_many :voters, class_name: 'User', dependent: :destroy, foreign_key: :voter_id

    def rating
      if (count_votes = votes.count) == 0
        count_useful, count_useless = 0, 0
      else  
        count_useful = votes.where(useful: true).count
        count_useless = count_votes - count_useful
      end
      { useful: count_useful, useless: count_useless }
    end
  end
end
