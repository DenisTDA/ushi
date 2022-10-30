class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :url, :name, presence: true
end
