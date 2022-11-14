module VotesHelper
  def vote_new(voteable)
    voteable.votes.new
  end
end
