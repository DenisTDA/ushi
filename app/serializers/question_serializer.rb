class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :author_id, :updated_at

  has_many :comments
  has_many :links
  has_many :files, serializer: FileSerializer
end
