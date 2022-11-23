class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :url, :name, presence: true

  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }

  def gist?
    url.start_with?('https://gist.github.com/')
  end
end
