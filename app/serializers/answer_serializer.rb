class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :author_id, :created_at, :updated_at

  belongs_to :question
  belongs_to :author
  has_many :comments
  has_many :links
  has_many :files, serializer: FileSerializer   
end
