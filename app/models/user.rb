class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise  :database_authenticatable,
          :registerable,
          :recoverable,
          :rememberable,
          :validatable,
          :confirmable,
          :omniauthable, omniauth_providers: %i[github google_oauth2 mailru_oauth2 vkontakte]

  has_many :replies, class_name: 'Answer', foreign_key: :author_id
  has_many :problems, class_name: 'Question', foreign_key: :author_id
  has_many :votes, foreign_key: :voter_id
  has_many :questions, through: :votes, source: :voteable, source_type: 'Question'
  has_many :answers, through: :votes, source: :voteable, source_type: 'Answer'
  has_many :comments
  has_many :inquiries, class_name: 'Question', through: :reviews,
                       source: :commentable, source_type: :Question
  has_many :responses, class_name: 'Answer', through: :reviews,
                       source: :commentable, source_type: :Answer
  has_many :authorizations, dependent: :destroy

  def self.find_for_oauth(auth)
    Registration::FindForOauth.call(auth)
  end

  def author?(item)
    id.eql?(item.author_id)
  end

  def able_to_vote?(voteable)
    select_vote(voteable).empty?
  end

  def status_vote(voteable)
    select_vote(voteable).first.useful ? "\u2705" : "\u26D4" if select_vote(voteable).first
  end

  def load_vote(voteable)
    select_vote(voteable)&.first
  end

  private

  def select_vote(voteable)
    votes.where(voteable_type: voteable.class.name, voteable_id: voteable.id)
  end
end
