class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :url, :name, presence: true 
  #validates :url, http_url: true
  validates_format_of :url, with: URI::regexp(%w(http https))

  def gist?
    self.url.start_with?('https://gist.github.com/')
  end
end
