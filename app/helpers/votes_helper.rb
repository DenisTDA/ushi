module VotesHelper
  def vote_new(voteable)
    voteable.votes.new
  end

  def key_cache_vote(voteable, user)
    votes = voteable.votes.count
    right = user&.able_to_vote?(voteable)
    "#{votes}-namber-of-votes-#{right}"
  end
end
